module WidgetsInc
  module Types
    class UnvalidatedAddress < ::Dry::Struct
      attribute :address_line_1, Types::Strict::String
      attribute :address_line_2, Types::Strict::String.optional
      attribute :address_line_3, Types::Strict::String.optional
      attribute :address_line_4, Types::Strict::String.optional
      attribute :city, Types::Strict::String
      attribute :zip_code, Types::Strict::String
    end
  end
end