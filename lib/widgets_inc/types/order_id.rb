# typed: strict
module WidgetsInc
  module Types
    class OrderId < ::WidgetsInc::SimpleType
      class << self
        extend T::Sig

        sig {params(field_name: Symbol).returns(T.proc.params(value: String).returns(OrderId))}
        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_string.(field_name, 50, value)
              .fmap { |value| new(value: value) }
          end
        end
      end
    end
  end
end