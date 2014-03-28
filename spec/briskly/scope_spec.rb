require 'spec_helper'
require 'briskly/scope'

describe Briskly::Scope do

  let(:results) { [{ foo: 'bar' }] }
  let(:store)   { double('Store', key: 'en:foo', search: results) }
  let(:stores)  { [store] }

  subject { described_class.new(stores) }

  it 'initializes with stores' do
    expect(subject).to be_a described_class
  end

  describe '#search' do

    it 'returns an hash with the store key' do
      expect(subject.search('foo').keys).to eql(['en:foo'])
    end

    it 'returns the search result' do
      expect(subject.search('foo')['en:foo'].first).to eql({ foo: 'bar' })
    end

  end

end
