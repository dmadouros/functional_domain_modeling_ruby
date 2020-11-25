Dry::Types.load_extensions(:maybe)

module WidgetsInc
  module Types
    include Dry.Types()

    OrderId = Types::Strict::String
    OrderLineId = Types::Strict::String
    GizmoCode = Types::Strict::String
    WidgetCode = Types::Strict::String
    UnitQuantity = Types::Strict::Integer
    KilogramQuantity = Types::Strict::Float
    Price = Types::Strict::Float
    ZipCode = Types::Strict::String
    BillingAmount = Types::Strict::Float

    OrderQuantity = UnitQuantity | KilogramQuantity
    ProductCode = WidgetCode | GizmoCode
    # PlaceOrderEvent = Types.Instance(OrderPlaced) | Types.Instance(BillableOrderPlaced) | Types.Instance(OrderAcknowledgmentSent)
  end
end