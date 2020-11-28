# typed: false
module WidgetsInc
  module Types
    class UnvalidatedOrderLine < ::Dry::Struct
      attribute :order_line_id, Types::Strict::String
      attribute :product_code, Types::Strict::String
      attribute :quantity, Types::Strict::Float | Types::Strict::Integer
    end
  end
end