require "dry-types"
require "dry-struct"
require "dry-monads"
require "dry/monads/do"
require "dry-schema"

require "widgets_inc/version"

require "widgets_inc/util/constrained_type"
require "widgets_inc/util/simple_type"

require "widgets_inc/types"
require "widgets_inc/types/unvalidated_customer_info"
require "widgets_inc/types/string_50"
require "widgets_inc/types/email_address"
require "widgets_inc/types/personal_name"
require "widgets_inc/types/customer_info"
require "widgets_inc/types/unvalidated_address"
require "widgets_inc/types/zip_code"
require "widgets_inc/types/address"
require "widgets_inc/types/unvalidated_order_line"
require "widgets_inc/types/unvalidated_order"
require "widgets_inc/types/order_line_id"
require "widgets_inc/types/unit_quantity"
require "widgets_inc/types/kilogram_quantity"
require "widgets_inc/types/order_quantity"
require "widgets_inc/types/gizmo_code"
require "widgets_inc/types/widget_code"
require "widgets_inc/types/product_code"
require "widgets_inc/types/order_line_id"
require "widgets_inc/types/validated_order_line"
require "widgets_inc/types/order_id"
require "widgets_inc/types/validated_order"

Dry::Schema.load_extensions(:monads)

module WidgetsInc
  extend ::Dry::Monads::Do::Mixin
  extend ::Dry::Monads[:result, :list]

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

  def self.to_product_code
    ->(check_product_code_exists, product_code) do

      check_product = -> (product_code) {
        if check_product_code_exists.(product_code)
          Success(product_code)
        else
          Falure("Invalid: #{product_code}")
        end
      }

      product_code
        .then(&Types::ProductCode.create(:product_code))
        .bind(&check_product)
    end
  end

  def self.to_validated_order_line
    -> (check_product_code_exists, unvalidated_order_line) do
      call do
        order_line_id = bind unvalidated_order_line.order_line_id
          .then(&Types::OrderLineId.create(:order_line_id))
        product_code = bind unvalidated_order_line.product_code
          .then(&->(product_code) { to_product_code.(check_product_code_exists, product_code) })
        quantity = bind unvalidated_order_line.quantity
          .then(&-> (value) { Types::OrderQuantity.create(:quantity).(product_code, value) })

        validated_order_line = ::WidgetsInc::Types::ValidatedOrderLine.new(
          order_line_id: order_line_id,
          product_code: product_code,
          quantity: quantity,
        )

        Success(validated_order_line)
      end
    end
  end

  def self.validate_order
    -> (check_product_code_exists, check_address_exists, unvalidated_order) do
      call do
        to_address_local = -> (unvalidated_address) { to_address.(check_address_exists, unvalidated_address) }
        to_validated_order_line_local = -> (unvalidated_order_line) { to_validated_order_line.(check_product_code_exists, unvalidated_order_line) }

        order_id = bind unvalidated_order.order_id
          .then(&Types::OrderId.create(:order_id))
        customer_info = bind unvalidated_order.customer_info
          .then(&to_customer_info)
        shipping_address = bind unvalidated_order.shipping_address
          .then(&to_address_local)
        billing_address = bind unvalidated_order.billing_address
          .then(&to_address_local)

        lines = bind ::Dry::Monads::List[*unvalidated_order.lines.map(&to_validated_order_line_local)].typed(::Dry::Monads::Result).traverse

        validated_order = Types::ValidatedOrder.new(
          order_id: order_id,
          customer_info: customer_info,
          shipping_address: shipping_address,
          billing_address: billing_address,
          lines: lines.value,
        )

        Success(validated_order)
      end
    end
  end
end
