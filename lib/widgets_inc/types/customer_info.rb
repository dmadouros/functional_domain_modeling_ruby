module WidgetsInc
  module Types
    class CustomerInfo < ::Dry::Struct
      attribute :name, Types.Instance(PersonalName)
      attribute :email_address, EmailAddress.type
    end
  end
end