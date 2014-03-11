require 'briskly'

class Briskly::Element

  attr_reader :term
  attr_reader :metadata

  def initialize(term, metadata = nil)
    raise ArgumentError unless term
    @term = term
    @metadata = metadata
  end

  # TODO: implement this method on C
  def matches?(keyword)
    term.downcase.include? keyword.downcase
  end

end
