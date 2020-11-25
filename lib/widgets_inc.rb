require "dry-types"
require "dry-struct"
require "dry-monads"
require "dry/monads/do"
require "dry-schema"

require "widgets_inc/version"

require "widgets_inc/util/constrained_type"

require "widgets_inc/types"
require "widgets_inc/types/unvalidated_customer_info"
require "widgets_inc/types/string_50"
require "widgets_inc/types/email_address"
require "widgets_inc/types/personal_name"
require "widgets_inc/types/customer_info"
require "widgets_inc/types/unvalidated_address"
require "widgets_inc/types/zip_code"
require "widgets_inc/types/address"

Dry::Schema.load_extensions(:monads)

module WidgetsInc
  extend ::Dry::Monads::Do::Mixin
  extend ::Dry::Monads[:result]

  def self.to_customer_info
    -> (unvalidated_customer_info) {
      call do
        first_name = bind unvalidated_customer_info.first_name
          .then(&Types::String50.create(:first_name))
        last_name = bind unvalidated_customer_info.last_name
          .then(&Types::String50.create(:last_name))
        email_address = bind unvalidated_customer_info.email_address
          .then(&Types::EmailAddress.create(:email_address))

        name = Types::PersonalName.new(
          first_name: first_name,
          last_name: last_name,
        )

        customer_info = Types::CustomerInfo.new(
          name: name,
          email_address: email_address,
        )

        Success(customer_info)
      end
    }
  end

  def self.to_address
    -> (check_address_exists, unvalidated_address) do
      call do
        checked_address = check_address_exists.(unvalidated_address)

        address_line_1 = bind checked_address.address_line_1
          .then(&Types::String50.create(:address_line_1))
        address_line_2 = bind checked_address.address_line_2
          .then(&Types::String50.create_option(:address_line_2))
        address_line_3 = bind checked_address.address_line_3
          .then(&Types::String50.create_option(:address_line_3))
        address_line_4 = bind checked_address.address_line_4
          .then(&Types::String50.create_option(:address_line_4))
        city = bind checked_address.city
          .then(&Types::String50.create(:city))
        zip_code = bind checked_address.zip_code
          .then(&Types::ZipCode.create(:zip_code))

        address = Types::Address.new(
          address_line_1: address_line_1,
          address_line_2: address_line_2,
          address_line_3: address_line_3,
          address_line_4: address_line_4,
          city: city,
          zip_code: zip_code,
        )

        Success(address)
      end
    end
  end
end
