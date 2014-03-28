require 'briskly'
require 'string_ext/normalise'

class Briskly::Element

  attr_reader :term
  attr_reader :data


  def initialize(term, data = nil)
    raise ArgumentError unless term
    @term       = term
    @normalised = @term.normalise
    @data       = data
  end

  # TODO: implement this method on C
  # also maybe when storing, store already denormalized
  def matches?(keyword)
    keyword = keyword.normalise # get rid of accents and the like

    return false if keyword.length > @normalised.length

    keyword.length.times do |index|
      compare = keyword[index]
      target  = @normalised[index]

      next if compare == target
      return false
    end

    true
  end
end
