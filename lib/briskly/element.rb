require 'briskly'

class Briskly::Element

  attr_reader :term
  attr_reader :data

  def initialize(term, data = nil)
    raise ArgumentError unless term
    @term = term
    @data = data
  end

  # TODO: implement this method on C
  def matches?(keyword)
    term.downcase.include? keyword.downcase
  end

end
