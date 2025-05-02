# frozen_string_literal: true

# Puppet::CatalogDiff
module Puppet::CatalogDiff
  class Puppetdbfactory
    @@puppetdb_loaded = false
    def self.puppetdb_url()
      begin
        require 'puppet/util/puppetdb'
        @@puppetdb_loaded = true
        puppetdb_url = Puppet::Util::Puppetdb.config.server_urls[0]
      rescue LoadError
        # PuppetDB is not available, so we can't use it
        # This is fine, we can still run the catalog diff without it
        puppetdb_url = 'https://puppetdb:8081'
      end
      puppetdb_url
    end

    def self.puppetdb_loaded?()
      @@puppetdb_loaded
    end
  end
end
