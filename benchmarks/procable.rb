require 'ostruct'
require 'benchmark'
require_relative '../lib/procable'

$condition = 'a'.freeze

class PropertyFilter
  include Procable.new

  def initialize(condition)
    @condition = condition
  end

  def filter(property)
    property.name.start_with?(@condition) &&
      property.value.end_with?(@condition)
  end

  def call(property)
    property.name.start_with?(@condition) &&
      property.value.end_with?(@condition)
  end
end

class StaticPropertyFilter
  extend Procable.new(:check)

  def self.check(property)
    property.name.start_with?($condition) &&
      property.value.end_with?($condition)
  end
end

class HashMapper
  include Procable.new

  def call(tuple)
    OpenStruct.new(key: tuple[0], val: tuple[1])
  end
end

properties = (1..1_000).each_with_object([]) { |e, a| a.concat([OpenStruct.new(name: 'ab', value: 'ba')]) }

Benchmark.bmbm do |x|
  x.report("include Procable") do
    properties.select(&PropertyFilter.new($condition))
  end

  x.report("extend Procable") do
    properties.select(&StaticPropertyFilter)
  end

  x.report("block") do
    properties.select { |property| property.name.start_with?($condition) && property.value.end_with?($condition) }
  end
end
