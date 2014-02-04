require 'spec_helper'
require 'briskly/collection'

describe Briskly::Collection do

  describe '#new' do
    it 'accepts a key' do
      expect(described_class.new(key: 'mycol').key).to eql('mycol')
    end

    it 'has a default key' do
      expect(described_class.new.key).to eql('default')
    end
  end

  describe '#store' do

    context 'given an array of values' do
      it 'does not raise errors' do
        expect { subject.store ['add', 'foo'] }.to_not raise_error
      end
    end

    context 'given an array of hashes' do
      it 'does not raise errors' do
        expect { subject.store(col1: ['bob', 'alice']) }.to_not raise_error
      end
    end

  end

  describe '#search' do

    context 'given array of values' do
      it 'returns the matching values' do
        subject.store ['bob', 'alice']
        expect(subject.search('bob')).to eql(['bob'])
      end

      it 'ignores case on the query' do
        subject.store ['Bob']
        expect(subject.search('bob')).to eql(['Bob'])
      end

      it 'ignores case on the keyword' do
        subject.store ['bob']
        expect(subject.search('Bob')).to eql(['bob'])
      end
    end

  end
end
