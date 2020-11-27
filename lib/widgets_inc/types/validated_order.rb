module WidgetsInc
  module Types
    class ValidatedOrder < ::Dry::Struct
      attribute :order_id, Types.Instance(OrderId)
      attribute :customer_info, Types.Instance(CustomerInfo)
      attribute :shipping_address, Types.Instance(Address)
      attribute :billing_address, Types.Instance(Address)
      attribute :lines, Types::Array.of(Types.Instance(ValidatedOrderLine))
    end
  end
end