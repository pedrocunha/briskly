require 'briskly'
require 'briskly/keyword'

class Briskly::Element

  attr_reader :data
  attr_reader :keyword

  def initialize(keyword, data = nil)
    raise ArgumentError unless keyword

    @keyword      = Briskly::Keyword.new(keyword)
    @data         = data
  end

  def keyword(internal = nil)
    internal == :internal ? @keyword : @keyword.to_s
  end

end
