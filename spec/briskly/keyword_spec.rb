# encoding: UTF-8

require 'spec_helper'
require 'briskly/keyword'

describe Briskly::Keyword do

  describe '#to_s' do
    subject { described_class.new('foo') }

    it 'returns the keyword' do
      expect(subject.to_s).to eq('foo')
    end
  end

  describe '#normalised' do
    subject { described_class.new('foo-bar-ão') }

    it 'removes accents and dashes' do
      expect(subject.normalised).to eq('foo bar ao')
    end
  end

end
