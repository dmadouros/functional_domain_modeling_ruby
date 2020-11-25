module WidgetsInc
  module Types
    class PersonalName < ::Dry::Struct
      attribute :first_name, String50.type
      attribute :last_name, String50.type
    end
  end
end