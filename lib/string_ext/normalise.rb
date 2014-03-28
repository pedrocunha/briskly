require 'iconv'

module StringNormalise
  def normalise
    _normaliser.iconv(self)
      .to_s
      .downcase
      .gsub(/[^a-z -]/, '')
      .gsub(/[\s-]+/, ' ')
  end

  private

  def _normaliser
    @@_normalizer ||= Iconv.new('us-ascii//ignore//translit', 'utf-8')
  end

  ::String.send(:include, self)
end
