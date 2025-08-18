require 'puppet/face'
require 'json'
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'catalog-diff', 'puppetdbfactory.rb'))

begin
  require 'parallel'
  HAS_PARALLEL_GEM = true
rescue LoadError
  HAS_PARALLEL_GEM = false
end

Puppet::Face.define(:catalog, '0.0.1') do
  action :diff do
    summary 'Compare catalogs from different puppet versions.'
    arguments '<catalog1> <catalog2>'
    puppetdb_url = Puppet::CatalogDiff::Puppetdbfactory.puppetdb_url()
    hostcert = Puppet.settings[:hostcert]
    hostprivkey = Puppet.settings[:hostprivkey]
    localcacert = Puppet.settings[:localcacert]

    option '--fact_search=' do
      summary 'Fact search used to filter which catalogs are compiled and compared'

      default_to { 'kernel=Linux' }
    end

    option '--output_report=' do
      summary 'Save the final report as json'
    end

    option '--content_diff' do
      summary 'Whether to show a diff for File resource content'
    end

    option '--show_resource_diff' do
      summary 'Display differences between resources in unified diff format'
    end

    option '--exclude_classes' do
      summary 'Do not print classes in resource diffs'
    end

    option '--exclude_defined_resources' do
      summary 'Do not print defined resources in resource diffs'
    end

    option '--exclude_resource_types=' do
      summary 'A comma-separated list of (capitalized) resource types to exclude from the diff'
    end

    option '--ignore_parameters=' do
      summary 'A comma-separated list of resource parameters to ignore in diff'
    end

    option '--[no-]filter_old_env' do
      summary "Whether to filter nodes on the old server's environment in PuppetDB"
      default_to { true }
    end

    option '--old_catalog_from_puppetdb' do
      summary "Get old catalog from PuppetDB inside of compile master. Defaults to #{puppetdb_url}. Overwrite with --old_puppetdb"
    end

    option '--new_catalog_from_puppetdb' do
      summary "Get new catalog from PuppetDB inside of compile master. Defaults to #{puppetdb_url}. Overwrite with --new_puppetdb"
    end

    option '--changed_depth=' do
      summary 'The number of nodes to display sorted by changes'
      default_to { '10' }
    end

    option '--threads=' do
      summary 'The number of connections for the compiles to use'
      default_to { '10' }
    end

    option '--certless' do
      summary 'Use the certless catalog API (Puppet >= 6.3.0)'
    end

    option '--node_list=' do
      summary 'A manual list of nodes to run catalog diffs against'
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

    option '--derive_trusted_facts' do
      summary 'Derive trusted facts from node name when using certless API. When disabled, Puppet will use trusted facts from PuppetDB.'
    end

    description <<-EOT
      Prints the differences between catalogs compiled by different puppet master to help
      during migrating to a new Puppet version.
    EOT
    notes <<-NOTES
      The diff tool recognizes catalogs in yaml, marshall, or pson format.

      Validation Process:

       - Grab a catalog from your existing machine running the old version
       - Configure your new Puppet master, copy the facts from your old master
         to the new one
       - Compile the catalog for this host on the new master:

            puppet master --compile fqdn > fqdn.pson

       - Puppet puts a header in some catalogs compiled in this way, remove it if present
       - At this point you should have 2 different catalogs. To compare them run:

            puppet catalog diff <catalog1> <catalog2>
       - Alternatively you can process a directory containing matching files
       - i.e. path/to/old/node_name.yaml and path/to/new/node_name.yaml
                   puppet catalog diff <path/to/old> <path/to/new>

      This code only validates the catalogs, it cannot tell you if the behavior of
      the providers that interpret the catalog has changed so testing is still
      recommended, this is just one tool to take away some of the uncertainty

    NOTES
    examples <<-EOT
      Compare host catalogs:

      $ puppet catalog diff host-2.6.yaml host-3.0.pson
      $ puppet catalog diff /tmp/old_catalogs /tmp/new_catalogs
    EOT

    when_invoked do |catalog1, catalog2, options|
      require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'catalog-diff', 'differ.rb'))
      require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'catalog-diff', 'findcatalogs.rb'))
      Puppet.notice('Add --debug for realtime output, add --render-as {json,yaml} for parsed output')

      # raise "You must pass unique paths to the arguments (#{catalog1} = #{catalog2})" if catalog1 == catalog2

      # Sanity check for mismatched arguments
      raise 'You must pass a file,diretory or hostname to both parameters' if (File.directory?(catalog1) && File.file?(catalog2)) || (File.file?(catalog1) && File.directory?(catalog2))

      nodes = {}

      if File.directory?(catalog1) && File.directory?(catalog2)
        # User passed us two directories full of pson
        found_catalogs = Puppet::CatalogDiff::FindCatalogs.new(catalog1, catalog2).return_catalogs(options)
        new_catalogs = found_catalogs.keys

        if HAS_PARALLEL_GEM
          results = Parallel.map(new_catalogs) do |new_catalog|
            node_name    = File.basename(new_catalog, File.extname(new_catalog))
            old_catalog  = found_catalogs[new_catalog]
            node_summary = Puppet::CatalogDiff::Differ.new(old_catalog, new_catalog).diff(options)
            [node_name, node_summary]
          end
          nodes = results.to_h
        else
          thread_count = 1
          mutex = Mutex.new

          Array.new(thread_count) do
            Thread.new(nodes, new_catalogs, options) do |nodes, new_catalogs, options|
              while new_catalog = mutex.synchronize { new_catalogs.pop }
                node_name    = File.basename(new_catalog, File.extname(new_catalog))
                old_catalog  = found_catalogs[new_catalog]
                node_summary = Puppet::CatalogDiff::Differ.new(old_catalog, new_catalog).diff(options)
                mutex.synchronize { nodes[node_name] = node_summary }
              end
            end
          end.each(&:join)
        end
      elsif File.file?(catalog1) && File.file?(catalog2)
        # User passed us two files
        node_name = File.basename(catalog2, File.extname(catalog2))
        nodes[node_name] = Puppet::CatalogDiff::Differ.new(catalog1, catalog2).diff(options)

      else
        # User passed us two hostnames
        old_catalogs = Dir.mktmpdir("#{catalog1.tr('/', '_')}-")
        new_catalogs = Dir.mktmpdir("#{catalog2.tr('/', '_')}-")
        @pull_output = Puppet::Face[:catalog, '0.0.1'].pull(
          old_catalogs, new_catalogs,
          options[:fact_search],
          old_server: catalog1, new_server: catalog2,
          changed_depth: options[:changed_depth],
          threads: options[:threads],
          filter_old_env: options[:filter_old_env],
          certless: options[:certless],
          old_catalog_from_puppetdb: options[:old_catalog_from_puppetdb],
          new_catalog_from_puppetdb: options[:new_catalog_from_puppetdb],
          old_puppetdb: options[:old_puppetdb],
          old_puppetdb_tls_cert: options[:old_puppetdb_tls_cert],
          old_puppetdb_tls_key: options[:old_puppetdb_tls_key],
          old_puppetdb_tls_ca: options[:old_puppetdb_tls_ca],
          old_puppetserver_tls_cert: options[:old_puppetserver_tls_cert],
          old_puppetserver_tls_key: options[:old_puppetserver_tls_key],
          old_puppetserver_tls_ca: options[:old_puppetserver_tls_ca],
          new_puppetdb: options[:new_puppetdb],
          node_list: options[:node_list],
          derive_trusted_facts: options[:derive_trusted_facts]
        )
        diff_output = Puppet::Face[:catalog, '0.0.1'].diff(old_catalogs, new_catalogs, options)
        nodes = diff_output
        FileUtils.rm_rf(old_catalogs)
        FileUtils.rm_rf(new_catalogs)
        nodes[:pull_output] = @pull_output
        return nodes
      end
      raise 'No nodes were matched' if nodes.size.zero?

      with_changes = nodes.select { |_node, summary| summary.is_a?(Hash) && !summary[:node_percentage].zero? }
      most_changed = with_changes.sort_by { |_node, summary| summary[:node_percentage] }.map do |node, summary|
        { node => summary[:node_percentage] }
      end

      most_differences = with_changes.sort_by { |_node, summary| summary[:node_differences] }.map do |node, summary|
        { node => summary[:node_differences] }
      end
      total_nodes = nodes.size
      nodes[:total_percentage]   = (nodes.map { |_node, summary| (summary.is_a?(Hash) && summary[:node_percentage]) || nil }.compact.reduce { |acc, elem| acc.to_f + elem } / total_nodes)
      nodes[:with_changes]       = with_changes.size
      nodes[:most_changed]       = most_changed.reverse.take(((options.key?(:changed_depth) && options[:changed_depth].to_i) || 10))
      nodes[:most_differences]   = most_differences.reverse.take(((options.key?(:changed_depth) && options[:changed_depth].to_i) || 10))
      nodes[:total_nodes]        = total_nodes
      nodes[:date]               = Time.new.iso8601
      nodes[:all_changed_nodes]  = with_changes.keys
      nodes[:pull_output]        = @pull_output unless @pull_output.nil?

      if options[:output_report]
        Puppet.notice("Writing report to disk: #{options[:output_report]}")
        File.write(options[:output_report], JSON.pretty_generate(nodes))
      end

      nodes
    end

    when_rendering :console do |nodes|
      require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'catalog-diff', 'formater.rb'))

      format = Puppet::CatalogDiff::Formater.new
      nodes.map do |node, summary|
        next if %i[total_percentage total_nodes most_changed with_changes most_differences pull_output date all_changed_nodes].include?(node)

        format.node_summary_header(node, summary, :node_percentage) + summary.map do |header, value|
          next if value.nil?

          case value
          when Hash
            value.map do |resource_id, resource|
              next if resource.nil?

              if resource.is_a?(Hash) && resource.key?(:type) && !%i[params_in_old params_in_new].include?(header)
                # If we find an actual resource print it out
                format.resource_reference(header, resource_id, resource)
              elsif resource.is_a?(Array)
                next unless resource.any?

                # Format string diffs
                format.string_diff(header, resource_id, resource)
              else
                next if resource.nil?

                # Format hash diffs
                format.params_diff(header, resource_id, resource)
              end
            end
          when Array
            next if value.empty?

            # Format arrays
            format.list(header, value)
          else
            format.key_pair(header, value)
          end
        end.delete_if { |x| x.nil? || x == [] }.join("\n")
      end.join("\n") + "#{format.node_summary_header("#{nodes[:with_changes]} out of #{nodes[:total_nodes]} nodes changed.", nodes, :total_percentage)}\n#{format.list_hash('Nodes with the most changes by percent changed', nodes[:most_changed])}\n\n#{format.list_hash('Nodes with the most changes by differences', nodes[:most_differences], '')}#{format.render_pull(nodes[:pull_output]) if nodes.key?(:pull_output)}"
    end
  end
end
