# typed: true
module WidgetsInc
  module Types
    class PricedOrderLine < ::Dry::Struct
      attribute :order_line_id, Types.Instance(OrderLineId)
      attribute :product_code, Types::ProductCode.type
      attribute :quantity, Types::OrderQuantity.type
      attribute :line_price, Types.Instance(Price)
    end
  end
end