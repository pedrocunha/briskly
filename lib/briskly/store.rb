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

      # Check if term is already stored
      # nil if not
      trie_index = @store.get(element.normalised)

      unless trie_index 
        @store.add element.normalised, index
        trie_index = index
      end

      # Keeping an ordered array so later search
      # respects the order of terms inserted
      @elements[trie_index] ||= []
      @elements[trie_index].push [element, index] 
    end
  end

  def search(keyword, options = {})
    element = Briskly::Element.new(keyword)

    # 1) Get all matching elements
    # 2) Retrieve their respective Briskly::Elements
    # 3) Make sure we flatten the array of arrays
    # 4) Sort by their index position
    # 5) Get rid of the indexes and just return Briskly::Elements
    result  = @store.children_with_values(element.normalised)
                .map  { |_, index|  @elements[index] }
                .flatten(1)
                .sort { |a,b| a[1] <=> b[1] }
                .map(&:first)

    limit = options.fetch(:limit, result.length) - 1
    result[0..limit]
  end
end

require 'briskly/element'
