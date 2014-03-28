require 'i18n'

module StringNormalise
  def normalise
    I18n.transliterate(self)
      .downcase
      .gsub(/[^a-z -]/, '')
      .gsub(/[\s-]+/, ' ')
  end

  ::String.send(:include, self)
end
