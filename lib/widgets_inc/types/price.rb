# typed: strict
module WidgetsInc
  module Types
    class Price < ::WidgetsInc::SimpleType
      class << self
      extend T::Sig

        sig {params(field_name: Symbol).returns(T.proc.params(value: Float).returns(Price))}
        def create(field_name)
          -> (value) {
            ::WidgetsInc::Util::ConstrainedType.create_float.(field_name, 0.0, 1000.0, value)
              .fmap { |value| new(value: value) }
          }
        end

        sig {params(quantity: T.any(Float, Integer)).returns(T.proc.params(price: Price).returns(Price))}
        def multiply(quantity)
          -> (price) {
            case price
            when ::WidgetsInc::Types::Price
              create_unsafe(:line_price).(quantity * ::WidgetsInc::Types::Price.value(price))
            end
          }
        end
      end
    end
  end
end