require 'spec_helper'
require 'briskly/element'

describe Briskly::Element do

  context 'one keyword' do

    subject { described_class.new('foo', { a: 2 }) }

    describe '#new' do
      it 'accepts a keyword and data' do
        expect(subject).to be_a described_class
      end

      it 'allows access to the keyword' do
        expect(subject.keyword).to eq('foo')
      end

      it 'allows access to the internal keyword instance' do
        expect(subject.keyword(:internal)).to be_a Briskly::Keyword
      end

      it 'allows access to its data' do
        expect(subject.data).to eql(a: 2)
      end
    end

  end

  context 'alternatives' do
    subject { described_class.new('foo', { a: 2 }, ['bar', 'bear']) }

    it 'converts alternatives to keyword elements' do
      expect(subject.alternatives.first.to_s).to eql('bar')
    end
  end

  context 'without keywords' do
    it 'raises ArgumentError' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end
