module WidgetsInc
  module Types
    class CustomerInfo < ::Dry::Struct
      attribute :name, Types.Instance(PersonalName)
      attribute :email_address, Types.Instance(EmailAddress)
    end
  end
end