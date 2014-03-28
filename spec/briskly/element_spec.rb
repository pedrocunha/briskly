# encoding: UTF-8

require 'spec_helper'
require 'briskly/element'

describe Briskly::Element do

  subject { described_class.new('foo', { a: 2 }) }

  describe '#new' do
    it 'accepts a term and data' do
      expect(subject).to be_a described_class
    end

    it 'allows access to the term' do
      expect(subject.term).to eql('foo')
    end

    it 'allows access to its data' do
      expect(subject.data).to eql(a: 2)
    end
  end

  describe '#normalised' do
    subject { described_class.new('foo-bar-ão', { a: 2 }) }

    it 'removes accents and dashes' do
      expect(subject.normalised).to eq('foo bar ao')
    end
  end

  context 'without a term' do
    it 'raises ArgumentError' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end
