# typed: false
module WidgetsInc
  module Types
    class PricedOrder < ::Dry::Struct
      attribute :order_id, Types.Instance(OrderId)
      attribute :customer_info, Types.Instance(CustomerInfo)
      attribute :shipping_address, Types.Instance(Address)
      attribute :billing_address, Types.Instance(Address)
      attribute :amount_to_bill, Types.Instance(BillingAmount)
      attribute :lines, Types::Array.of(Types.Instance(PricedOrderLine))
    end
  end
end