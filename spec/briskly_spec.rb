require 'spec_helper'
require 'briskly'

describe Briskly, 'integration' do

  it 'does not allow initialization' do
    expect { described_class.new }.to raise_exception
  end

  context 'searching single collections' do
    described_class.store('en:foo').with([
      { term: 'foo' },
      { term: 'foobear' }
    ])

    subject { described_class.on('en:foo').search('foo') }

    it 'returns matching values for en:foo collection' do
      expect(subject['en:foo'].map(&:term)).to eql(['foo', 'foobear'])
    end
  end
  

  context 'searching multiple collections' do
    described_class.store('en:foo').with([
      { term: 'foo' },
      { term: 'foobear' }
    ])

    described_class.store('en:bar').with([
      { term: 'bar' },
      { term: 'bar-bear' },
      { term: 'foo' }
    ])

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
