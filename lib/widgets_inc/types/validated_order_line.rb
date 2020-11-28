# typed: true
module WidgetsInc
  module Types
    class ValidatedOrderLine < ::Dry::Struct
      attribute :order_line_id, Types.Instance(Types::OrderLineId)
      attribute :product_code, Types::ProductCode.type
      attribute :quantity, Types::OrderQuantity.type
    end
  end
end