## Procable

Ruby symbols respond to the `:to_proc` message which creates a callable Proc object when passed as an argument to a method like `map` or `select`.

A simple implementation could be viewed as:

```
class Symbol
  def to_proc
    Proc.new do |obj, *args|
      obj.send self, *args
    end
  end
end
```

This allows us to write code as:

```
require 'ostruct'

objects = [ OpenStruct.new(name: 'a'), OpenStruct.new(name: 'b') ]
puts objects.map { |obj| obj.name } # => ['a', 'b']
puts objects.map(&:name) # => ['a', 'b']
```

Procable allows us to extract the 'mapping' logic into a separate class by wiring the `:to_proc` on the instance or the class

```
require 'ostruct'

objects = [ OpenStruct.new(value: 10), OpenStruct.new(value: 20) ]

class Mapper
  include Procable.new

  def initialize(factor)
    @factor = factor
  end

  # :call is used by default
  # You can supply any method in the Procable initializer to be used instead of :call
  def call(obj)
    obj.value * factor
  end
end

puts objects.map(&Mapper.new(30)) # => [300, 600]
```

By extracting the logic into a separate class, Procable allows us to create more composable, reusable and testable pieces of code:

```
require 'ostruct'

object = OpenStruct.new(value: 10)

Mapper.new(10).call(object) == 100
```

Procable can use any method you define on the class:

```
class Mapper
  include Procable.new(:transform)

  def transform(obj)
    # ... some fancy logic here
  end
end
```

It can also be extended instead of included:

```
class Mapper
  extend Procable.new(:transform)

  def self.transform(obj)
    # ... some fancy logic here
  end
end
```

See the examples folder for more usages
