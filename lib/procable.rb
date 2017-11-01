class Procable < Module
  def initialize(method_to_proc = :call)
    define_method :to_proc do
      method(method_to_proc).to_proc
    end

    define_singleton_method :to_proc do
      method(method_to_proc).to_proc
    end
  end
end
