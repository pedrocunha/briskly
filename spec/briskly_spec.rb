require 'spec_helper'
require 'briskly'

describe Briskly, 'integration' do

  before do
    described_class.store('en:foo').with([
      { term: 'foo' },
      { term: 'foobear' }
    ])
  end

  context 'searching single collections' do

    subject { described_class.on('en:foo').search('foo') }

    it 'returns matching values for en:foo collection' do
      expect(subject['en:foo'].map(&:term)).to eql(['foo', 'foobear'])
    end
  end

  context 'limiting results' do

    it 'returns only 1 element' do
      subject = described_class.on('en:foo').search('foo', limit: 1)
      expect(subject['en:foo']).to have(1).item
    end

    it 'returns all results' do
      subject = described_class.on('en:foo').search('foo')
      expect(subject['en:foo']).to have(2).items
    end

  end
  

  context 'searching multiple collections' do
    before do 
      described_class.store('en:bar').with([
        { term: 'bar' },
        { term: 'bar-bear' },
        { term: 'foo' }
      ])
    end

    subject { described_class.on('en:foo', 'en:bar').search('foo') }

    it 'returns 2 collections' do
      expect(subject.keys.length).to eql(2)
    end

    it 'returns matching values for en:foo collection' do
      expect(subject['en:foo'].map(&:term)).to eql(['foo', 'foobear'])
    end

    it 'returns matching values for en:bar collection' do
      expect(subject['en:bar'].map(&:term)).to eql(['foo'])
    end

  end

end
