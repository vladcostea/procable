require 'ostruct'
require_relative '../lib/procable'

class ObjectMapper
  extend Procable.new

  def self.call(hash)
    key, value = hash.first
    OpenStruct.new(name: key, value: value)
  end
end

class OddFilter
  extend Procable.new

  def self.call(obj)
    obj.value.odd?
  end
end

hashes = [{ a: 1}, { b: 2}, { c: 3}]

puts hashes.map(&ObjectMapper).select(&OddFilter)
