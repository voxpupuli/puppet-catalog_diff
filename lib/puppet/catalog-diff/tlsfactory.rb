# frozen_string_literal: true

# Puppet::CatalogDiff
module Puppet::CatalogDiff
  # create a proper TLS context for the Puppet HTTP client
  class Tlsfactory
    def self.ssl_context(tls_cert, tls_key, tls_ca)
      # Load certificates to make a connection to a possible foreign / not-by-default-trusted HTTPS resource
      x509 = Puppet::X509::CertProvider.new
      cacerts = x509.load_cacerts_from_pem(File.read(tls_ca, encoding: Encoding::UTF_8))
      client_cert = x509.load_client_cert_from_pem(File.read(tls_cert, encoding: Encoding::UTF_8))
      private_key = x509.load_private_key_from_pem(File.read(tls_key, encoding: Encoding::UTF_8))
      prov = Puppet::SSL::SSLProvider.new
      prov.create_context(revocation: false, cacerts: cacerts, private_key: private_key, client_cert: client_cert, include_system_store: true, crls: [])
    end
  end
end
