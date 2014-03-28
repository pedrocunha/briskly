require 'briskly'
require 'trie'

class Briskly::Store

  attr_reader :key

  def initialize(key)
    @key      = key
    @store    = nil
    @elements = []
  end

  def with(values)
    @store = Trie.new

    values.each do |value|
      element = Briskly::Element.new(value[:term], value[:data])
      @store.add element.normalised, @elements.length
      @elements.push element
    end
  end

  def search(keyword, options = {})
    element = Briskly::Element.new(keyword)
    result  = @store.children_with_values(element.normalised).map do |_, index|
      @elements[index]
    end

    limit = options.fetch(:limit, result.length) - 1
    result[0..limit]
  end
end

require 'briskly/element'
