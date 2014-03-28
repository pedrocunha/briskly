require 'briskly'

class Briskly::Scope

  attr_reader :stores

  def initialize(stores)
    @stores = stores
  end

  def search(keyword, options = {})
    result = {}

    @stores.each do |store|
      result[store.key] = store.search(keyword, options)
    end

    result
  end
end
