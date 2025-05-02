# frozen_string_literal: true

# Puppet::CatalogDiff
module Puppet::CatalogDiff
  class Puppetdbfactory
    def self.puppetdb_url()
      begin
        require 'puppet/util/puppetdb'
        puppetdb_url = Puppet::Util::Puppetdb.config.server_urls[0]
      rescue LoadError
        # PuppetDB is not available, so we can't use it
        # This is fine, we can still run the catalog diff without it
        puppetdb_url = 'PuppetDB plugin is not available! Install puppetdb-termini to enable PuppetDB functionality.'
      end
      puppetdb_url
    end
  end
end
