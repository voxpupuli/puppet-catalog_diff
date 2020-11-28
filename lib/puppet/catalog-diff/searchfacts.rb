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
      filter_env = (options[:filter_old_env]) ? old_env : nil
      active_nodes = find_nodes_puppetdb(filter_env)
      if active_nodes.empty?
        raise 'No active nodes were returned from your fact search'
      end
      active_nodes
    end

    def build_query(env, version)
      base_query = ['and', ['=', ['node', 'active'], true]]
      query_field_catalog_environment = Puppet::Util::Package.versioncmp(version, '3') > 0 ? 'catalog_environment' : 'catalog-environment'
      base_query.concat([['=', query_field_catalog_environment, env]]) if env
      real_facts = @facts.reject { |_k, v| v.nil? }
      query = base_query.concat(real_facts.map { |k, v| ['=', ['fact', k], v] })
      classes = Hash[@facts.select { |_k, v| v.nil? }].keys
      classes.each do |c|
        capit = c.split('::').map { |n| n.capitalize }.join('::')
        query = query.concat(
          [['in', 'certname',
            ['extract', 'certname',
             ['select-resources',
              ['and',
               ['=', 'type', 'Class'],
               ['=', 'title', capit]]]]]],
        )
      end
      query
    end

    def get_puppetdb_version(connection)
      result = connection.request_get('/pdb/meta/v1/version', 'Accept' => 'application/json')
      if result.code.to_i == 200
        body = JSON.parse(result.body)
        version = body['version']
        Puppet.debug("Got PuppetDB version: #{version} from HTTP API.")
      else
        version = '2.3'
        Puppet::debug("Getting PuppetDB version failed because HTTP API query returned code #{result.code}. Falling back to PuppetDB version #{version}.")
      end
      version
    end

    def find_nodes_puppetdb(env)
      require 'puppet/util/puppetdb'
      server_url = Puppet::Util::Puppetdb.config.server_urls[0]
      port = server_url.port
      use_ssl = port != 8080
      connection = Puppet::Network::HttpPool.http_instance(server_url.host, port, use_ssl)
      puppetdb_version = get_puppetdb_version(connection)
      query = build_query(env, puppetdb_version)
      json_query = URI.escape(query.to_json)
      begin
        result = connection.request_get("/pdb/query/v4/nodes?query=#{json_query}", 'Accept' => 'application/json')
        if result.code.to_i >= 400
          puppetdb_version = '2.3'
          Puppet::debug("Query returned HTTP code #{result.code}. Falling back to older version of API used in PuppetDB version #{puppetdb_version}.")
          query = build_query(env, puppetdb_version)
          json_query = URI.escape(query.to_json)
          result = connection.request_get("/v4/nodes/?query=#{json_query}", 'Accept' => 'application/json')
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
