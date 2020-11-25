module WidgetsInc
  module Types
    class UnvalidatedCustomerInfo < ::Dry::Struct
      attribute :first_name, Types::Strict::String
      attribute :last_name, Types::Strict::String
      attribute :email_address, Types::Strict::String
    end
  end
end