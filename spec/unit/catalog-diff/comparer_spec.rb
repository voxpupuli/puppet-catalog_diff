require 'spec_helper'
require 'puppet/catalog-diff/comparer'

describe Puppet::CatalogDiff::Comparer do
  include Puppet::CatalogDiff::Comparer
  describe :extract_titles do
    let(:resources) do
      [
        {
          resource_id: 'foo',
        },
        {
          resource_id: 'bar',
        }
      ]
    end

    it 'should return resource ids' do
      extract_titles(resources).should eq(['foo', 'bar'])
    end
  end

  describe :compare_resources do
    let(:res1) do
      [
        {
          resource_id: 'file.foo',
          type: 'file',
          parameters: {
            name: 'foo',
            alias: 'baz',
            path: '/foo',
            content: 'foo content',
          }
        }
      ]
    end

    let(:res2) do
      [
        {
          resource_id: 'file.foo',
          type: 'file',
          parameters: {
            name: 'foo',
            alias: 'baz',
            path: '/food',
            content: 'foo content 2',
          }
        }
      ]
    end

    it 'should return a diff without options' do
      diffs = compare_resources(res1, res2, {})
      expect(diffs[:old]).to eq({res1[0][:resource_id] => res1[0]})
      expect(diffs[:new]).to eq({res2[0][:resource_id] => res2[0]})
      expect(diffs[:old_params]).to eq({'file.foo' => {content: 'foo content', path: '/foo'}})
      expect(diffs[:new_params]).to eq({'file.foo' => {content: 'foo content 2', path: '/food'}})
      expect(diffs[:content_differences]['file.foo']).to match(%r{^\+foo content 2$})
      expect(diffs[:string_diffs]).to be_empty
    end

    it 'should return string_diffs with show_resource_diff' do
      diffs = compare_resources(res1, res2, {show_resource_diff: true})
      expect(diffs[:string_diffs]['file.foo'][2]).to eq("-\t     content => \"foo content\"")
    end

    it 'should return a diff without path parameter' do
      diffs = compare_resources(res1, res2, {ignore_parameters: 'path'})
      expect(diffs[:old_params]).to eq({'file.foo' => {content: 'foo content'}})
      expect(diffs[:new_params]).to eq({'file.foo' => {content: 'foo content 2'}})
    end
  end
end
