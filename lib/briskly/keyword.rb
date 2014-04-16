require 'briskly'
require 'i18n'

class Briskly::Keyword

  def initialize(keyword)
    @keyword = keyword
  end

  def to_s
    @keyword
  end

  def normalised
    @_normalised ||= begin
      I18n.transliterate(@keyword)
        .downcase
        .gsub(/[^a-z -]/, '')
        .gsub(/[\s-]+/, ' ')
    end
  end

end
