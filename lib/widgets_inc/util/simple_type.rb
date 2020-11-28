# typed: ignore
module WidgetsInc
  class SimpleType
    class << self
      def create(field_name)
        raise NotImplementedError
      end

      def create_unsafe(field_name)
        -> (*args) {
          create(field_name).(*args).value!
        }
      end

      def value(instance)
        case instance
        in self
          instance.instance_variable_get(:@value)
        end
      end

      private

      instance_eval { private :new }
    end

    def deconstruct_keys(_)
      {value: @value}
    end

    def ==(other)
      self.class == other.class && self.value == other.value
    end

    def hash
      value.hash
    end

    private

    def initialize(value:)
      @value = value
    end

    protected

    attr_reader :value
  end
end