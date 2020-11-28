# typed: false
module WidgetsInc
  module Types
    class BillingAmount < ::WidgetsInc::SimpleType
      class << self
        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_float.(field_name, 0.0, 10000.0, value)
              .fmap { |value| new(value: value) }
          end
        end

        def sum_prices
          -> (prices) do
            total = prices.sum { |price| ::WidgetsInc::Types::Price.value(price) }

            total.then(&create(:total))
          end
        end
      end
    end
  end
end