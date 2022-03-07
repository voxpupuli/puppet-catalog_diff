# frozen_string_literal: true

require 'spec_helper'

describe 'catalog_diff::viewer' do
  on_supported_os.each do |os, os_facts|
    next unless os_facts[:kernel] == 'Linux'
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
