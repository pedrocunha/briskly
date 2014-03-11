require 'spec_helper'
require 'briskly/element'

describe Briskly::Element do

  describe '#new' do

    subject { described_class.new('foo', { a: 2 }) }

    it 'accepts a term and metadata' do
      expect(subject).to be_a described_class
    end

    it 'allows access to the term' do
      expect(subject.term).to eql('foo')
    end

    it 'allows access to its metadata' do
      expect(subject.metadata).to eql(a: 2)
    end
  end

  context 'without a term' do
    it 'raises ArgumentError' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end
