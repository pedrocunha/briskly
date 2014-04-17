require 'briskly'
require 'briskly/element'
require 'trie'

class Briskly::Store

  attr_reader :key

  def initialize(key)
    @key      = key
    @store    = Trie.new
  end

  def with(values)
    @store    = Trie.new
    elements = {}

    values.each_with_index do |value, index|

      keywords = Array.new(1) { value[:keyword] }.flatten(1)

      keywords.each do |keyword|
        alternatives = keywords - [ keyword ]
        element      = Briskly::Element.new(keyword, value[:data], alternatives)
        normalised   = element.keyword(:internal).normalised

        # We need to make sure we keep the index
        # and in order to avoid loops always order
        # the array after each insertion
        elements[normalised] ||= []
        elements[normalised].push([element, index])
                             .sort! { |a,b| a[1] <=> b[1] }
      end

    end


    elements.each do |key, values|
      @store.add key, values
    end
  end

  def search(keyword, options = {})
    keyword = Briskly::Keyword.new(keyword)

    result  = @store.children_with_values(keyword.normalised)
                    .map(&:last)
                    .flatten(1)
                    .sort{ |a, b| a[1] <=> b[1] }

    
    limit   = options.fetch(:limit, result.length)
    counter = 0
    output  = []
    related = []


    # If n elements have the same index that
    # means they are related. Trie will give
    # the best keyword match on it's first
    # position so we should ignore the others
    #
    # `related` keeps the list of related keywords
    result.each do |element|
      next if related[element[1]] 
      related[element[1]] = true

      output << element[0]

      counter += 1
      break if counter == limit
    end
    
    output
  end
end

