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
  # also maybe when storing, store already denormalized
  def matches?(keyword)
    return false if keyword.length > term.length

    keyword.length.times do |index|
      compare = keyword[index]
      target  = term[index]

      next if self.class.isEqual(compare, target) || 
              self.class.isEqualIgnoringCase(compare, target) ||
              self.class.isEqualWithoutSpecialChars(compare, target) ||
              self.class.isEqualWithoutLatinChars(compare, target)
      
      return false
    end

    true
  end

  private
  def self.special_chars
    /-+/
  end

  def self.isEqual(compare, target)
    compare == target
  end

  def self.isEqualIgnoringCase(compare, target)
    compare.downcase == target.downcase
  end

  def self.isEqualWithoutSpecialChars(compare, target)
    compare.gsub(special_chars, ' ') == target.gsub(special_chars, ' ')
  end

  def self.isEqualWithoutLatinChars(compare, target)
    return false if !compare.match(/./) || !target.match(/./)

    compare_index = ACCENTED_CHARS.index(compare) 
    compare = compare_index ? NON_ACCENTED_CHARS[compare_index] : compare

    target_index  = ACCENTED_CHARS.index(target)
    target = target_index ? NON_ACCENTED_CHARS[target_index] : target

    compare == target
  end

  ACCENTED_CHARS = "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž"
  NON_ACCENTED_CHARS = "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz"
end
