# typed: strict
module WidgetsInc
  class SimpleType
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(field_name: T.untyped).returns(T.untyped)}
      def create(field_name)
        raise NotImplementedError
      end

      sig {params(field_name: T.untyped).returns(Proc)}
      def create_unsafe(field_name)
        -> (*args) {
          create(field_name).(*args).value!
        }
      end

      sig {params(instance: BasicObject).returns(T.untyped)}
      def value(instance)
        case instance
        when self
          instance.instance_variable_get(:@value)
        end
      end

      private

      instance_eval { private :new }
    end

    sig {params(_: T.untyped).returns(T::Hash[T.untyped, T.untyped])}
    def deconstruct_keys(_)
      {value: @value}
    end

    sig { params(other: SimpleType).returns(T::Boolean) }
    def ==(other)
      self.class == other.class && self.value == other.value
    end

    sig { returns(Integer) }
    def hash
      value.hash
    end

    private

    sig { params(value: T.untyped).void }
    def initialize(value:)
      @value = T.let(value, T.untyped)
    end

    protected

    sig { returns(T.untyped) }
    attr_reader :value
  end
end