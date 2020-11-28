# typed: strict
module WidgetsInc
  module Types
    class KilogramQuantity < ::WidgetsInc::SimpleType
      class << self
        extend T::Sig

        sig {params(field_name: Symbol).returns(T.proc.params(value: Float).returns(KilogramQuantity))}
        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_float.(field_name, 0.5, 100.0, value)
              .fmap { |value| new(value: value) }
          end
        end
      end
    end
  end
end