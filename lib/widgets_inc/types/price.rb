module WidgetsInc
  module Types
    class Price < ::WidgetsInc::SimpleType
      class << self
        def create(field_name)
          -> (value) {
            ::WidgetsInc::Util::ConstrainedType.create_float.(field_name, 0.0, 1000.0, value)
              .fmap { |value| new(value: value) }
          }
        end

        def multiply(quantity)
          -> (price) {
            case price
            in ::WidgetsInc::Types::Price(value:)
              create_unsafe(:line_price).(quantity * value)
            end
          }
        end
      end
    end
  end
end