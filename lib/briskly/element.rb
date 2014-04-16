require 'briskly'
require 'briskly/keyword'

class Briskly::Element

  attr_reader :data
  attr_reader :keyword
  attr_reader :alternatives

  def initialize(keyword, data = nil, alternatives = [])
    raise ArgumentError unless keyword

    @keyword      = Briskly::Keyword.new(keyword)
    @data         = data
    @alternatives = alternatives.map { |alternative| Briskly::Keyword.new(alternative) }
  end

  def keyword(internal = nil)
    internal == :internal ? @keyword : @keyword.to_s
  end

end
