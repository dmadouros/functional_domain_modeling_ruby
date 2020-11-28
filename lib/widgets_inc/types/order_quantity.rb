# typed: true
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