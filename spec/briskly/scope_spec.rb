require 'spec_helper'
require 'briskly/scope'

describe Briskly::Scope do

  let(:stores) {
    [ double('Store', key: 'en:foo') ]
  }

  subject { described_class.new(stores) }

  it 'initializes with stores' do
    expect(subject).to be_a described_class
  end

  describe '#search' do
    before do
      stores.first.stub(:search).and_return([{ foo: 'bar'}])
    end

    it 'returns an hash with the store key' do
      expect(subject.search('foo').keys).to eql(['en:foo'])
    end

    it 'returns the search result' do
      expect(subject.search('foo')['en:foo'].first).to eql({ foo: 'bar' })
    end
  end

end
