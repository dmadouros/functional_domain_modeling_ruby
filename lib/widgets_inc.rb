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
end
