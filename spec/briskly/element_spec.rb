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

  describe '#matches?' do

    subject { described_class.new('foo-bar-ão', { a: 2 }) }

    it 'matches if beginning of word' do
      expect(subject.matches?('fo')).to be_true
    end

    it 'does not match if not equal of beginning of word' do
      expect(subject.matches?('oo')).to be_false
    end

    it 'does not match when keyword is bigger than the term' do
      expect(subject.matches?('foo-bar-ãoa')).to be_false
    end

    it 'is case insensitive' do
      expect(subject.matches?('FOO')).to be_true
    end

    it 'matches the space with the dash' do
      expect(subject.matches?('foo bar')).to be_true
    end

    it 'ignores the accents' do
      expect(subject.matches?('foo-bar-ao')).to be_true
    end

    it 'also ignores the accents on the keyword' do
      expect(subject.matches?('foo-bar-aó')).to be_true
    end
  end

  context 'without a term' do
    it 'raises ArgumentError' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end
