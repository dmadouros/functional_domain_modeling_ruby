# typed: ignore
module WidgetsInc
  module Types
    module OrderQuantity
      class << self
        def type
          ::WidgetsInc::Types.Instance(::WidgetsInc::Types::UnitQuantity) | ::WidgetsInc::Types.Instance(::WidgetsInc::Types::KilogramQuantity)
        end

        def create(field_name)
          -> (product_code, value) do
            case product_code
            in ::WidgetsInc::Types::GizmoCode
              KilogramQuantity.create(field_name).(value)
            in ::WidgetsInc::Types::WidgetCode
              UnitQuantity.create(field_name).(value)
            end
          end
        end
      end
    end
  end
end