require 'briskly'

class Briskly::Scope

  attr_reader :stores

  def initialize(stores)
    @stores = stores
  end

  def search(keyword)
    result = {}

    @stores.each do |store|
      result[store.key] = store.search(keyword)
    end

    result
  end
end
