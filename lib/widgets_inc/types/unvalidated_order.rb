module WidgetsInc
  module Types
    class UnvalidatedOrder < ::Dry::Struct
      attribute :order_id, Types::Strict::String
      attribute :customer_info, Types.Instance(UnvalidatedCustomerInfo)
      attribute :shipping_address, Types.Instance(UnvalidatedAddress)
      attribute :billing_address, Types.Instance(UnvalidatedAddress)
      attribute :lines, Types::Array.of(Types.Instance(UnvalidatedOrderLine))
    end
  end
end