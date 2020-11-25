module WidgetsInc
  module Types
    class Address < ::Dry::Struct
      attribute :address_line_1, String50.type
      attribute :address_line_2, String50.type.maybe
      attribute :address_line_3, String50.type.maybe
      attribute :address_line_4, String50.type.maybe
      attribute :city, String50.type
      attribute :zip_code, ZipCode.type
    end
  end
end