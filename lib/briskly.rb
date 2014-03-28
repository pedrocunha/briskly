require 'briskly/version'

module Briskly
  @@storage = {}

  module_function

  def store(key)
    @@storage[key] = Briskly::Store.new(key)
  end

  def on(*keys)
    stores = [keys].flatten.map { |key| @@storage[key] || Briskly::Store.new(key) }
    Briskly::Scope.new stores
  end
end

require 'briskly/store'
require 'briskly/scope'
