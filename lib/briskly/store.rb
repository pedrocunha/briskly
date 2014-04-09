require 'briskly'
require 'trie'

class Briskly::Store

  attr_reader :key

  def initialize(key)
    @key      = key
    @store    = Trie.new
    @elements = {}
  end

  def with(values)
    @store    = Trie.new
    @elements = {}

    values.each_with_index do |value, index|
      element = Briskly::Element.new(value[:term], value[:data])

      # No need to re-store term
      unless stored?(element.normalised)
        @store.add element.normalised
        @elements[element.normalised] ||= []
      end

      # Keeping an ordered array so later search
      # respects the order of terms inserted
      @elements[element.normalised].push([element, index])
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
                .map  { |term, _|  @elements[term] }
                .flatten(1)
                .sort { |a,b| a[1] <=> b[1] }
                .map(&:first)

    limit = options.fetch(:limit, result.length) - 1
    result[0..limit]
  end

  private
  def stored?(value)
    @elements.has_key? value
  end
end

require 'briskly/element'
