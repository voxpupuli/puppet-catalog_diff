# frozen_string_literal: true

require 'spec_helper'

describe 'catalog_diff::viewer' do
  on_supported_os.each do |os, os_facts|
    next unless os_facts[:kernel] == 'Linux'
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_apache__vhost('172.16.254.254:1495') }
      it { is_expected.to contain_htpasswd('puppet') }
      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_file('/var/www/.htpasswd') }
      it { is_expected.to contain_vcsrepo('/var/www/diff') }
    end
  end
end
