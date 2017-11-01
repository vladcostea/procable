require 'ostruct'
require_relative '../lib/procable'

class ObjectFilter
  include Procable.new(:filter)

  def initialize(condition)
    @condition = condition
  end

  def filter(obj)
    obj.name.start_with?(@condition) &&
      obj.value.end_with?(@condition)
  end
end

properties = [
  OpenStruct.new(name: 'ab', value: 'ba'),
  OpenStruct.new(name: 'ac', value: 'ca'),
  OpenStruct.new(name: 'bc', value: 'cb')
]

puts properties.select(&ObjectFilter.new('a'))
