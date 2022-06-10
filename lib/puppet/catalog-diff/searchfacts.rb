require 'puppet/network/http_pool'
require 'uri'
require 'json'
# Puppet::CatalogDiff
module Puppet::CatalogDiff
  # SearchFacts returns facts from local data, Puppet API, or PuppetDB
  class SearchFacts
    def initialize(facts)
      @facts = Hash[facts.split(',').map { |f| f.split('=') }]
    end

    def find_nodes(options = {})
      # Pull all nodes from PuppetDB
      old_env = options[:old_server].split('/')[1]
      Puppet.debug('Using PuppetDB to find active nodes')
      filter_env = options[:filter_old_env] ? old_env : nil
      active_nodes = find_nodes_puppetdb(filter_env, options[:puppetdb])
      if active_nodes.empty?
        raise 'No active nodes were returned from your fact search'
      end

      active_nodes
    end

    def build_query(env, version)
      base_query = ['and', ['=', %w[node active], true]]
      query_field_catalog_environment = Puppet::Util::Package.versioncmp(version, '3') >= 0 ? 'catalog_environment' : 'catalog-environment'
      base_query.concat([['=', query_field_catalog_environment, env]]) if env
      real_facts = @facts.reject { |_k, v| v.nil? }
      query = base_query.concat(real_facts.map { |k, v| ['=', ['fact', k], v] })
      classes = Hash[@facts.select { |_k, v| v.nil? }].keys
      classes.each do |c|
        capit = c.split('::').map(&:capitalize).join('::')
        query.concat(
          [['in', 'certname',
            ['extract', 'certname',
             ['select-resources',
              ['and',
               ['=', 'type', 'Class'],
               ['=', 'title', capit]]]]]]
        )
      end
      query
    end

    def get_puppetdb_version(server)
      headers = { 'Accept' => 'application/json'}
      result = Puppet.runtime[:http].get(URI("#{server}/pdb/meta/v1/version"), headers: headers)
      if result.code == 200
        body = JSON.parse(result.body)
        version = body['version']
        Puppet.debug("Got PuppetDB version: #{version} from HTTP API.")
      else
        version = '2.3'
        Puppet::debug("Getting PuppetDB version failed because HTTP API query returned code #{result.code}. Falling back to PuppetDB version #{version}.")
      end
      version
    end

    def find_nodes_puppetdb(env, puppetdb)
      puppetdb_version = get_puppetdb_version(puppetdb)
      query = build_query(env, puppetdb_version)
      json_query = URI.escape(query.to_json)
      headers = { 'Accept' => 'application/json'}
      Puppet.debug("Querying #{puppetdb} for environment #{env}")
      begin
        result = Puppet.runtime[:http].get(URI("#{puppetdb}/pdb/query/v4/nodes?query=#{json_query}"), headers: headers)
        if result.code >= 400
          puppetdb_version = '2.3'
          Puppet::debug("Query returned HTTP code #{result.code}. Falling back to older version of API used in PuppetDB version #{puppetdb_version}.")
          query = build_query(env, puppetdb_version)
          json_query = URI.escape(query.to_json)
          result = Puppet.runtime[:http].get(URI("#{puppetdb}/pdb/query/v4/nodes?query=#{json_query}"), headers: headers)
        end
        filtered = PSON.parse(result.body)
      rescue PSON::ParserError => e
        raise "Error parsing json output of puppet search: #{e.message}"
      end
      names = filtered.map { |node| node['certname'] }
      names
    end
  end
end
