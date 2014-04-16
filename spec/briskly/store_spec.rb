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

    it 'stores an element' do
      expect(subject.with [{ keyword: 'foo', data: { :id => 100 } }]).to be_true
    end

    it 'data argument is optional' do
      expect(subject.with [{ keyword: 'foo' }]).to be_true
    end

    it 'keywords argument is mandatory' do
      expect{subject.with [{ data: 'foo' }]}.to raise_error
    end

    it 'stores an element with an array of keywords' do
      expect{subject.with [{ keyword: ['foo', 'bar'], data: 'foo' }]}.to_not raise_error
    end
  end

  describe '#search' do

    subject { described_class.new('en:foo') }


    context 'limiting results' do

      before do
        subject.with([
          { keyword: 'foo'     },
          { keyword: 'foobear' },
          { keyword: 'foobaz'  },
          { keyword: 'fooyolo' },
          { keyword: 'foocorse'},
          { keyword: 'foopizza'}
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
          { keyword: 'london' },
          { keyword: 'lon'    },
          { keyword: 'londa'  },
          { keyword: 'lonato' },
          { keyword: 'bear'   }
        ])
      end

      let(:result) { subject.search('lon') }

      it 'returns all matching results' do
        expect(result.length).to eql(4)
      end

      it 'respects the order of insertion' do
        expect(result.map(&:keyword)).to eql(['london', 'lon', 'londa', 'lonato'])
      end
    end

    context 'attached data' do
      it 'returns respective data' do
        subject.with([ keyword: 'bob', data: 1 ])
        expect(subject.search('bob').first.data).to eql(1)
      end
    end

    context 'ignores case-sensitive' do
      it 'ignores case on the keyword' do
        subject.with([ keyword: 'bob' ])
        expect(subject.search('Bob').first.keyword).to eql('bob')
      end

      it 'ignores case on the keywords' do
        subject.with([ keyword: 'Bob' ])
        expect(subject.search('bob').first.keyword).to eql('Bob')
      end
    end

    context 'matching partially keywords' do

      it 'returns a result if keyword length is smaller than keywords chars' do
        subject.with([ keyword: 'bob_is_nice' ])
        expect(subject.search('Bob').first.keyword).to eql('bob_is_nice')
      end

      it 'does not return a result if keyword length is bigger than keywords chars' do
        subject.with([ keyword: 'bob' ])
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
        subject.with([ keyword: 'foo', data: 1])
        subject.with([ keyword: 'foo', data: 2])
      end

      it 'returns only 1 element' do
        expect(subject.search('foo')).to have(1).item
      end

      it 'returns the right data' do
        expect(subject.search('foo').first.data).to eql(2)
      end

    end

    context 'same keywords' do
      before do
        subject.with([ 
          { keyword: 'foo', data: 1 },
          { keyword: 'foo', data: 2 }
        ])
      end

      let(:result) { subject.search('foo') }

      it 'returns 2 results' do
        expect(result).to have(2).items
      end

      it 'respects order' do
        expect(result.map(&:data)).to eql [1, 2]
      end
    end

    context 'multiple keywords' do
      before do
        subject.with([ 
          { keyword: ['foo', 'bar'], data: 1 },
          { keyword: 'bear', data: 2 }
        ])
      end

      let(:result) { subject.search('bar') }

      it 'returns 1 result for bar' do
        expect(result).to have(1).item
      end

      it 'returns data equal to 1' do
        expect(result.map(&:data)).to eql [1]
      end

    end

    context 'multiple keywords with similar names' do
      before do
        subject.with([ 
          { keyword: ['foo', 'foobar'] }
        ])
      end

      let(:result) { subject.search('foo') }

      it 'returns 1 result for foo' do
        expect(result).to have(1).item
      end

      it 'returns the element with keyword foo' do
        expect(result.map(&:keyword)).to eql ['foo']
      end

    end

    context 'multiple keywords with similar names but different elements' do
      before do
        subject.with([ 
          { keyword: ['foo', 'foobar'], data: 1 },
          { keyword: ['foobar'], data: 2 }
        ])
      end

      let(:result) { subject.search('foo') }

      it 'returns 2 result for foo' do
        expect(result).to have(2).item
      end

      it 'returns data' do
        expect(result.map(&:data)).to eql [1, 2]
      end

    end

  end

end
