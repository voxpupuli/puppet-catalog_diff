require 'puppet/face'
require 'digest'

Puppet::Face.define(:catalog, '0.0.1') do
  action :pull do
    description 'Pull catalogs from duel puppet masters'
    arguments '/tmp/old_catalogs /tmp/new_catalogs'
    begin
      require 'puppet/util/puppetdb'
      puppetdb_url = Puppet::Util::Puppetdb.config.server_urls[0]
    rescue LoadError
      # PuppetDB is not available, so we can't use it
      # This is fine, we can still run the catalog diff without it
      puppetdb_url = 'PuppetDB plugin is not available! Install puppetdb-termini to enable PuppetDB functionality.'
    end
    hostcert = Puppet.settings[:hostcert]
    hostprivkey = Puppet.settings[:hostprivkey]
    localcacert = Puppet.settings[:localcacert]

    option '--old_server=' do
      required
      summary 'This the valid certificate name or alt name for your old server'
    end

    option '--new_server=' do
      summary 'This the valid certificate name or alt name for your old server'

      default_to { Facter.value('networking.fqdn') }
    end

    option '--threads=' do
      summary 'The number of threads to use'
      default_to { '10' }
    end

    option '--[no-]filter_old_env' do
      summary "Whether to filter nodes on the old server's environment in PuppetDB"
    end

    option '--old_catalog_from_puppetdb' do
      summary "Get old catalog from PuppetDB inside of compile master. Defaults to #{puppetdb_url}. Overwrite with --old_puppetdb"
    end

    option '--new_catalog_from_puppetdb' do
      summary "Get new catalog from PuppetDB inside of compile master. Defaults to #{puppetdb_url}. Overwrite with --new_puppetdb"
    end

    option '--changed_depth=' do
      summary 'The number of problem files to display sorted by changes'

      default_to { '10' }
    end

    option '--certless' do
      summary 'Use the certless catalog API (Puppet >= 6.3.0)'
    end

    option '--old_puppetdb=' do
      summary 'URI to PuppetDB to find nodes if --node_list is not set. Also used to download old catalogs. Defaults to first server in puppetdb.conf'
      default_to { puppetdb_url }
    end

    option '--old_puppetdb_tls_cert=' do
      summary "Optional absolute path to a client certificate to authenticate against the old PuppetDB. If not provided, the Puppet Agent default certificate will be used. Defaults to #{hostcert}."
      default_to { hostcert }
    end

    option '--old_puppetdb_tls_key=' do
      summary "Optional absolute path to a TLS private key in pem format. If not provided, the Puppet Agent default key will be used. Defaults to #{hostprivkey}."
      default_to { hostprivkey }
    end

    option '--old_puppetdb_tls_ca=' do
      summary "Optional absolute path to a CA pem file. If not provided, the Puppet Agent CA will be used. Defaults to #{localcacert}."
      default_to { localcacert }
    end

    option '--old_puppetserver_tls_cert=' do
      summary "Optional absolute path to a client certificate to authenticate against the old Puppetserver. If not provided, the Puppet Agent default certificate will be used. Defaults to #{hostcert}."
      default_to { hostcert }
    end

    option '--old_puppetserver_tls_key=' do
      summary "Optional absolute path to a TLS private key in pem format. If not provided, the Puppet Agent default key will be used. Defaults to #{hostprivkey}."
      default_to { hostprivkey }
    end

    option '--old_puppetserver_tls_ca=' do
      summary "Optional absolute path to a CA pem file. If not provided, the Puppet Agent CA will be used. Defaults to #{localcacert}."
      default_to { localcacert }
    end

    option '--new_puppetdb=' do
      summary 'Used to download new catalogs. Defaults to first server in puppetdb.conf'
      default_to { puppetdb_url }
    end

    option '--node_list=' do
      summary 'A manual list of nodes to run catalog diffs against'
    end

    option '--derive_trusted_facts' do
      summary 'Derive trusted facts from node name when using certless API. When disabled, Puppet will use trusted facts from PuppetDB.'
    end

    description <<-EOT
      This action is used to seed a series of catalogs from two servers
    EOT
    notes <<-NOTES
      This will store files in pson format with the in the save directory. i.e.
      <path/to/seed/directory>/<node_name>.pson . This is currently the only format
      that is supported.

    NOTES
    examples <<-EOT
      Dump host catalogs:

      $ puppet catalog pull /tmp/old_catalogs /tmp/new_catalogs kernel=Linux --old_server puppet2.puppetlabs.vm --new_server puppet3.puppetlabs.vm
    EOT

    when_invoked do |catalog1, catalog2, args, options|
      require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'catalog-diff', 'searchfacts.rb'))
      require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'catalog-diff', 'compilecatalog.rb'))
      search_options = options
      search_options[:puppetdb] = search_options[:old_puppetdb]
      search_options[:puppetdb_tls_cert] = search_options[:old_puppetdb_tls_cert]
      search_options[:puppetdb_tls_key] = search_options[:old_puppetdb_tls_key]
      search_options[:puppetdb_tls_ca] = search_options[:old_puppetdb_tls_ca]

      nodes = if options[:node_list].nil?
                Puppet::CatalogDiff::SearchFacts.new(args).find_nodes(options)
              else
                options[:node_list].split(',')
              end
      raise "Problem finding nodes with query #{args}" unless nodes

      total_nodes = nodes.size
      thread_count = options[:threads].to_i
      compiled_nodes = []
      failed_nodes = {}
      mutex = Mutex.new

      Array.new(thread_count) do
        Thread.new(nodes, compiled_nodes, options) do |nodes, compiled_nodes, options|
          Puppet.debug(nodes)
          while node_name = mutex.synchronize { nodes.pop }
            begin
              if nodes.size.odd?
                old_server = Puppet::Face[:catalog, '0.0.1'].seed(
                  catalog1, node_name,
                  master_server: options[:old_server],
                  certless: options[:certless],
                  catalog_from_puppetdb: options[:old_catalog_from_puppetdb],
                  puppetdb: options[:old_puppetdb],
                  puppetdb_tls_cert: options[:old_puppetdb_tls_cert],
                  puppetdb_tls_key: options[:old_puppetdb_tls_key],
                  puppetdb_tls_ca: options[:old_puppetdb_tls_ca],
                  puppetserver_tls_cert: options[:old_puppetserver_tls_cert],
                  puppetserver_tls_key: options[:old_puppetserver_tls_key],
                  puppetserver_tls_ca: options[:old_puppetserver_tls_ca],
                  derive_trusted_facts: options[:derive_trusted_facts]
                )
                new_server = Puppet::Face[:catalog, '0.0.1'].seed(
                  catalog2, node_name,
                  master_server: options[:new_server],
                  certless: options[:certless],
                  catalog_from_puppetdb: options[:new_catalog_from_puppetdb],
                  puppetdb: options[:new_puppetdb],
                  derive_trusted_facts: options[:derive_trusted_facts]
                )
              else
                new_server = Puppet::Face[:catalog, '0.0.1'].seed(
                  catalog2, node_name,
                  master_server: options[:new_server],
                  certless: options[:certless],
                  catalog_from_puppetdb: options[:new_catalog_from_puppetdb],
                  puppetdb: options[:new_puppetdb],
                  derive_trusted_facts: options[:derive_trusted_facts]
                )
                old_server = Puppet::Face[:catalog, '0.0.1'].seed(
                  catalog1, node_name,
                  master_server: options[:old_server],
                  certless: options[:certless],
                  catalog_from_puppetdb: options[:old_catalog_from_puppetdb],
                  puppetdb: options[:old_puppetdb],
                  puppetdb_tls_cert: options[:old_puppetdb_tls_cert],
                  puppetdb_tls_key: options[:old_puppetdb_tls_key],
                  puppetdb_tls_ca: options[:old_puppetdb_tls_ca],
                  puppetserver_tls_cert: options[:old_puppetserver_tls_cert],
                  puppetserver_tls_key: options[:old_puppetserver_tls_key],
                  puppetserver_tls_ca: options[:old_puppetserver_tls_ca],
                  derive_trusted_facts: options[:derive_trusted_facts]
                )
              end
              mutex.synchronize { compiled_nodes + old_server[:compiled_nodes] }
              mutex.synchronize { compiled_nodes + new_server[:compiled_nodes] }
              mutex.synchronize do
                new_server[:failed_nodes][node_name].nil? ||
                  failed_nodes[node_name] = new_server[:failed_nodes][node_name]
              end
            rescue Exception => e
              Puppet.err(e.to_s)
            end
          end
        end
      end.each(&:join)
      output = {}
      output[:failed_nodes]         = failed_nodes
      output[:failed_nodes_total]   = failed_nodes.size
      output[:compiled_nodes]       = compiled_nodes.compact
      output[:compiled_nodes_total] = compiled_nodes.compact.size
      output[:total_nodes]          = total_nodes
      output[:total_percentage]     = (failed_nodes.size.to_f / total_nodes) * 100
      problem_files = {}

      failed_nodes.each do |node_name, error|
        # Extract the filename and the node a key of the same name
        match = %r{(\S*(/\S*\.pp|\.erb))}.match(error.to_s)
        if match
          (problem_files[match[1]] ||= []) << node_name
        else
          unique_token = Digest::MD5.hexdigest(error.to_s.gsub(node_name, ''))
          (problem_files["No-path-in-error-#{unique_token}"] ||= []) << node_name
        end
      end

      most_changed = problem_files.sort_by { |_file, nodes| nodes.size }.map do |file, nodes|
        { file => nodes.size }
      end

      output[:failed_to_compile_files] = most_changed.reverse.take(options[:changed_depth].to_i)

      example_errors = output[:failed_to_compile_files].map do |file_hash|
        example_error = file_hash.map do |file_name, _metric|
          example_node = problem_files[file_name].first
          error = failed_nodes[example_node].to_s
          { error => example_node }
        end.first
        example_error
      end
      output[:example_compile_errors] = example_errors
      output
    end
    when_rendering :console do |output|
      require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'catalog-diff', 'formater.rb'))
      format = Puppet::CatalogDiff::Formater.new
      output.map do |key, value|
        if value.is_a?(Array) && key == :failed_to_compile_files
          format.list_file_hash(key, value)
        elsif value.is_a?(Array) && key == :example_compile_errors
          format.list_error_hash(key, value)
        end
      end.join("\n")
    end
  end
end
