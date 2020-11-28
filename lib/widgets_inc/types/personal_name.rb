# typed: strict
module WidgetsInc
  module Types
    class PersonalName < ::Dry::Struct
      attribute :first_name, Types.Instance(String50)
      attribute :last_name, Types.Instance(String50)
    end
  end
end