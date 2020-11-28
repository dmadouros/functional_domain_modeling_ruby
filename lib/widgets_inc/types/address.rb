# typed: strict
module WidgetsInc
  module Types
    class Address < ::Dry::Struct
      attribute :address_line_1, Types.Instance(String50)
      attribute :address_line_2, Types.Instance(String50).maybe
      attribute :address_line_3, Types.Instance(String50).maybe
      attribute :address_line_4, Types.Instance(String50).maybe
      attribute :city, Types.Instance(String50)
      attribute :zip_code, Types.Instance(ZipCode)
    end
  end
end