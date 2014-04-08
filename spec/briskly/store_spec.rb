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
      expect(subject.with [{ term: 'foo', data: { :id => 100 } }]).to be_true
    end

    it 'data argument is optional' do
      expect(subject.with [{ term: 'foo' }]).to be_true
    end

    it 'term argument is mandatory' do
      expect{subject.with [{ data: 'foo' }]}.to raise_error
    end
  end

  describe '#search' do

    subject { described_class.new('en:foo') }


    context 'limiting results' do

      before do
        subject.with([
          { term: 'foo'     },
          { term: 'foobear' },
          { term: 'foobaz'  },
          { term: 'fooyolo' },
          { term: 'foocorse'},
          { term: 'foopizza'}
        ])
      end

      it 'returns only five elements' do
        result = subject.search('foo', limit: 5)
        expect(result).to have(5).items
      end

      it 'returns all results' do
        result = subject.search('foo')
        expect(result).to have(6).items
      end

    end

    context 'multiple results' do

      before do 
        subject.with([
          { term: 'london' },
          { term: 'lon'    },
          { term: 'londa'  },
          { term: 'lonato' },
          { term: 'bear'   }
        ])
      end

      let(:result) { subject.search('lon') }

      it 'returns all matching results' do
        expect(result.length).to eql(4)
      end

      it 'respects the order of insertion' do
        expect(result.map(&:term)).to eql(['london', 'lon', 'londa', 'lonato'])
      end
    end

    context 'attached data' do
      it 'returns respective data' do
        subject.with([ term: 'bob', data: 1 ])
        expect(subject.search('bob').first.data).to eql(1)
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

    context 'handling empty store' do
      it 'returns empty array' do
        expect(subject.search('foo')).to be_empty
      end
    end

    context 'overriding data' do

      before do
        subject.with([ term: 'foo', data: 1])
        subject.with([ term: 'foo', data: 2])
      end

      it 'returns only 1 element' do
        expect(subject.search('foo')).to have(1).item
      end

      it 'returns the right data' do
        expect(subject.search('foo').first.data).to eql(2)
      end

    end


  end

end
