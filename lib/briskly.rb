require "briskly/version"

class Briskly
  private_class_method :new

  def self.instance
    @@instance ||= new
  end

  def self.collection(key: 'default')
    Collection.new(key)
  end
end
