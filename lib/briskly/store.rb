require 'briskly'

class Briskly::Store

  attr_reader :key

  def initialize(key)
    @key = key
    @store = []
  end

  def with(values)
    @store = []

    values.each do |value|
      @store << Briskly::Element.new(value[:term], value[:metadata])
    end
  end

  def search(keyword)
    result = []

    @store.each do |element|
      result << element if element.matches?(keyword)
    end

    result
  end
end

require 'briskly/element'
