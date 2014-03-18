require 'briskly/version'

class Briskly
  private_class_method :new

  @@storage = {}

  def self.store(key)
    @@storage[key] = Briskly::Store.new(key)
  end

  def self.on(*keys)
    stores = [keys].flatten.map { |key| @@storage[key] || Briskly::Store.new(key) }
    Briskly::Scope.new stores
  end
end

require 'briskly/store'
require 'briskly/scope'
