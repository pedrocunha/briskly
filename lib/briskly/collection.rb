require 'briskly'

class Briskly::Collection

  attr_reader :key

  def initialize(key: 'default')
    @key = key
  end

  def search(query)
  end

  def store(data)
  end
end
