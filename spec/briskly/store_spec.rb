require 'spec_helper'
require 'briskly/store'

describe Briskly::Store do

  describe '#new' do

    it 'accepts a store name as argument' do
      expect(described_class.new('en:foo').key).to eql('en:foo')
    end

    it 'raises exception with multiple arguments' do
      expect{ described_class.new('en:foo', 'en:bar') }.to raise_error
    end
  end

  describe '#with' do

    subject { described_class.new('en:foo') }

    it 'stores an array of terms' do
      expect(subject.with [{ term: 'foo', metadata: { :id => 100 } }]).to be_true
    end

    it 'metadata argument is optional' do
      expect(subject.with [{ term: 'foo' }]).to be_true
    end

    it 'term argument is mandatory' do
      expect{subject.with [{ metadata: 'foo' }]}.to raise_error
    end
  end

  describe '#search' do

    subject { described_class.new('en:foo') }

    context 'multiple results' do
      let(:result) do 
        subject.with([
          { term: 'foo'     },
          { term: 'foobear' },
          { term: 'bear'    }
        ])

        subject.search('foo')
      end

      it 'returns all matching results' do
        expect(result.length).to eql(2)
      end

      it 'respects the order of insertion' do
        expect(result.map(&:term)).to eql(['foo', 'foobear'])
      end
    end

    context 'attached metadata' do
      it 'returns respective metadata' do
        subject.with([ term: 'bob', metadata: 1 ])
        expect(subject.search('bob').first.metadata).to eql(1)
      end
    end

    context 'ignores case-sensitive' do
      it 'ignores case on the keyword' do
        subject.with([ term: 'bob' ])
        expect(subject.search('Bob').first.term).to eql('bob')
      end

      it 'ignores case on the term' do
        subject.with([ term: 'Bob' ])
        expect(subject.search('bob').first.term).to eql('Bob')
      end
    end

    context 'matching partially term' do

      it 'returns a result if keyword length is smaller than term chars' do
        subject.with([ term: 'bob_is_nice' ])
        expect(subject.search('Bob').first.term).to eql('bob_is_nice')
      end

      it 'does not return a result if keyword length is bigger than term chars' do
        subject.with([ term: 'bob' ])
        expect(subject.search('BobIsNice')).to be_empty
      end
    end

  end

end
