require 'briskly'
require 'trie'

class Briskly::Store

  attr_reader :key

  def initialize(key)
    @key      = key
    @store    = Trie.new
    @elements = []
  end

  def with(values)
    @store    = Trie.new
    @elements = []

    values.each_with_index do |value, index|
      element = Briskly::Element.new(value[:term], value[:data])
      @store.add element.normalised, index
      @elements.push element
    end
  end

  def search(keyword, options = {})
    element = Briskly::Element.new(keyword)
    result  = @store.children_with_values(element.normalised)

    # Trie will return the weight on index 1
    result.sort! { |a,b| a[1] <=> b[1] } 

    # Restore the payload
    result.map! do |_, index|
      @elements[index]
    end

    limit = options.fetch(:limit, result.length) - 1
    result[0..limit]
  end
end

require 'briskly/element'
