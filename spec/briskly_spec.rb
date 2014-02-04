require 'spec_helper'
require 'briskly'

describe Briskly do

  it 'does not allow initialization' do
    expect { Briskly.new }.to raise_exception
  end

  it 'behaves like a singleton' do
    expect(Briskly.instance).to be_an_instance_of Briskly
  end

  it 'allows to access a collection' do
    expect(Briskly.collection).to_not raise_exception
  end

  context 'integration' do
    let(:collection) do
      collection = Briskly.collection
      collection.store ['foo', 'foo2']
    end

    it 'allows to store and search from the singleton' do
      result = collection.search('foo')
      expect(result).to eql(['foo', 'foo2'])
    end

    it 'does not return results from other collection' do
      collection2 = Briskly.collection(key: 'col2')
      collection2.store ['foo']
      result = collection2.search('foo')

      expect(result).to eql(['foo'])
    end
  end
end
