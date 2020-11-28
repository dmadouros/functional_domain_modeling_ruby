# typed: strict
module WidgetsInc
  module Types
    module OrderQuantity
      class << self
        extend T::Sig

        sig { returns(Dry::Types::Sum::Constrained) }
        def type
          ::WidgetsInc::Types.Instance(::WidgetsInc::Types::UnitQuantity) | ::WidgetsInc::Types.Instance(::WidgetsInc::Types::KilogramQuantity)
        end

        sig { params(field_name: Symbol).returns(T.proc.params(product_code: T.any(GizmoCode, WidgetCode), value: String).returns(T.any(KilogramQuantity, UnitQuantity))) }
        def create(field_name)
          -> (product_code, value) do
            case product_code
            when ::WidgetsInc::Types::GizmoCode
              KilogramQuantity.create(field_name).(value)
            when ::WidgetsInc::Types::WidgetCode
              UnitQuantity.create(field_name).(value)
            end
          end
        end
      end
    end
  end
end