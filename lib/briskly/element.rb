require 'briskly'
require 'i18n'

class Briskly::Element

  attr_reader :term
  attr_reader :data

  def initialize(term, data = nil)
    raise ArgumentError unless term
    @term = term
    @data = data
  end
  
  def normalised
    @_normalised ||= begin
      I18n.transliterate(@term)
        .downcase
        .gsub(/[^a-z -]/, '')
        .gsub(/[\s-]+/, ' ')
    end
  end
end
