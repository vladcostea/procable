RSpec.describe Procable do
  context 'when included' do
    class IncludingProcable
      include Procable.new

      def initialize(factor = 1)
        @factor = factor
      end

      def call(param)
        param * @factor
      end
    end

    it 'adds the to_proc method on the class instance' do
      expect(IncludingProcable.new).to respond_to(:to_proc)
    end

    it 'uses the :call method by default' do
      mapped = [1, 2, 3].map(&IncludingProcable.new(3))
      expect(mapped).to eq([3, 6, 9])
    end

    class IncludingProcableWithCustomMethod
      include Procable.new(:transform)

      def transform(param)
        param * 2
      end
    end

    it 'uses the custom method when provided' do
      mapped = [1, 2, 3].map(&IncludingProcableWithCustomMethod.new)
      expect(mapped).to eq([2, 4, 6])
    end
  end

  context 'when extended' do
    class ExtendingProcable
      extend Procable.new

      def self.call(param)
        param * 2
      end
    end

    it 'adds the to_proc method on the class instance' do
      expect(ExtendingProcable).to respond_to(:to_proc)
    end

    it 'uses the :call method by default' do
      mapped = [1, 2, 3].map(&ExtendingProcable)
      expect(mapped).to eq([2, 4, 6])
    end

    class ExtendingProcableWithCustomMethod
      extend Procable.new(:transform)

      def self.transform(param)
        param * 2
      end
    end

    it 'uses the custom method when provided' do
      mapped = [1, 2, 3].map(&ExtendingProcableWithCustomMethod)
      expect(mapped).to eq([2, 4, 6])
    end
  end
end
