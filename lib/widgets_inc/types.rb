Dry::Types.load_extensions(:maybe)

module WidgetsInc
  module Types
    include Dry.Types()

    # Price = Types::Strict::Float
    # BillingAmount = Types::Strict::Float

    # PlaceOrderEvent = Types.Instance(OrderPlaced) | Types.Instance(BillableOrderPlaced) | Types.Instance(OrderAcknowledgmentSent)
  end
end