require 'briskly'
require 'i18n'

class Briskly::Keyword

  def initialize(keyword)
    @keyword = FrozenString.get(keyword)
  end

  def to_s
    @keyword.to_s
  end

  def normalised
    @_normalised ||= begin
      I18n.transliterate(to_s)
        .downcase
        .gsub(/[^a-z -]/, '')
        .gsub(/[\s-]+/, ' ')
    end
  end

  class FrozenString
    module ClassMethods
      def get(string)
        @@repository ||= {}
        @@repository[string.freeze] ||= new(string.freeze)
      end
    end
    extend ClassMethods

    def initialize(string)
      @value = string
    end

    def to_str
      @value
    end

    alias_method :to_s, :to_str

    class << self
      private :new
    end
  end

end
