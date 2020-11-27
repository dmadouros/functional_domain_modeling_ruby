RSpec.describe WidgetsInc do
  include ::Dry::Monads[:result, :maybe]

  let(:first_name) { "Bilbo" }
  let(:last_name) { "Baggins" }
  let(:email_address) { "bilbo.baggins@example.com" }

  let(:unvalidated_customer_info) do
    ::WidgetsInc::Types::UnvalidatedCustomerInfo.new(
      first_name: first_name,
      last_name: last_name,
      email_address: email_address
    )
  end

  let(:unvalidated_address) do
    ::WidgetsInc::Types::UnvalidatedAddress.new(
      address_line_1: "1234 Main St.",
      address_line_2: "Unit 1A",
      address_line_3: nil,
      address_line_4: nil,
      city: "AnyCity",
      zip_code: "12345",
    )
  end

  let(:check_address_exists) do
    ->(unvalidated_address) { unvalidated_address }
  end

  let(:check_product_code_exists) do
    ->(_product_code) { true }
  end

  describe ".to_customer_info" do
    context "when all fields valid" do
      it "returns customer_info result" do
        actual = ::WidgetsInc.to_customer_info.(unvalidated_customer_info)

        expected = ::WidgetsInc::Types::CustomerInfo.new(
          name: ::WidgetsInc::Types::PersonalName.new(
            first_name: ::WidgetsInc::Types::String50.create_unsafe(:first_name).("Bilbo"),
            last_name: ::WidgetsInc::Types::String50.create_unsafe(:last_name).("Baggins"),
          ),
          email_address: ::WidgetsInc::Types::EmailAddress.create_unsafe(:email_address).("bilbo.baggins@example.com")
        )
        expect(actual).to eq(Success(expected))
      end
    end

    context "when first_name is invalid" do
      let(:first_name) { "" }

      it "returns failure" do
        actual = WidgetsInc.to_customer_info.(unvalidated_customer_info)

        expect(actual).to eq(Failure(["first_name: must be filled"]))
      end
    end

    context "when last_name is invalid" do
      let(:last_name) { "" }

      it "returns failure" do
        actual = WidgetsInc.to_customer_info.(unvalidated_customer_info)

        expect(actual).to eq(Failure(["last_name: must be filled"]))
      end
    end

    context "when email_address is invalid" do
      let(:email_address) { "" }

      it "returns failure" do
        actual = WidgetsInc.to_customer_info.(unvalidated_customer_info)

        expect(actual).to eq(Failure(["email_address: must be filled"]))
      end
    end
  end

  describe ".to_address" do
    context "when all fields valid" do
      it "returns address result" do
        actual = WidgetsInc.to_address.(check_address_exists, unvalidated_address)

        expected = ::WidgetsInc::Types::Address.new(
          address_line_1: ::WidgetsInc::Types::String50.create_unsafe(:address_line_1).("1234 Main St."),
          address_line_2: ::WidgetsInc::Types::String50.create_option_unsafe(:address_line_1).("Unit 1A"),
          address_line_3: None(),
          address_line_4: None(),
          city: ::WidgetsInc::Types::String50.create_unsafe(:city).("AnyCity"),
          zip_code: ::WidgetsInc::Types::ZipCode.create_unsafe(:zip_code).("12345"),
        )
        expect(actual).to eq(Success(expected))
      end
    end
  end

  describe ".validate_order" do
    let(:billing_address) do
      ::WidgetsInc::Types::UnvalidatedAddress.new(
        address_line_1: "4321 Pine St.",
        address_line_2: nil,
        address_line_3: nil,
        address_line_4: nil,
        city: "AnotherCity",
        zip_code: "67890",
      )
    end

    let(:unvalidated_order_line_1) do
      ::WidgetsInc::Types::UnvalidatedOrderLine.new(
        order_line_id: "1",
        product_code: "W7639",
        quantity: 10
      )
    end

    let(:unvalidated_order_line_2) do
      ::WidgetsInc::Types::UnvalidatedOrderLine.new(
        order_line_id: "2",
        product_code: "G6548",
        quantity: 14.2
      )
    end

    let(:unvalidated_order) do
      ::WidgetsInc::Types::UnvalidatedOrder.new(
        order_id: "987654321",
        customer_info: unvalidated_customer_info,
        shipping_address: unvalidated_address,
        billing_address: billing_address,
        lines: [unvalidated_order_line_1, unvalidated_order_line_2]
      )
    end

    context "when all fields valid" do
      it "returns validated_order result" do
        actual = WidgetsInc.validate_order.(check_product_code_exists, check_address_exists, unvalidated_order)

        personal_name = ::WidgetsInc::Types::PersonalName.new(
          first_name: ::WidgetsInc::Types::String50.create_unsafe(:first_name).("Bilbo"),
          last_name: ::WidgetsInc::Types::String50.create_unsafe(:last_name).("Baggins"),
        )

        expected_customer_info = ::WidgetsInc::Types::CustomerInfo.new(
          name: personal_name,
          email_address: ::WidgetsInc::Types::EmailAddress.create_unsafe(:email_address).("bilbo.baggins@example.com"),
        )

        expected_shipping_address = ::WidgetsInc::Types::Address.new(
          address_line_1: ::WidgetsInc::Types::String50.create_unsafe(:address_line_1).("1234 Main St."),
          address_line_2: ::WidgetsInc::Types::String50.create_option_unsafe(:address_line_2).("Unit 1A"),
          address_line_3: None(),
          address_line_4: None(),
          city: ::WidgetsInc::Types::String50.create_unsafe(:city).("AnyCity"),
          zip_code: ::WidgetsInc::Types::ZipCode.create_unsafe(:zip_code).("12345"),
        )

        expected_billing_address = ::WidgetsInc::Types::Address.new(
          address_line_1: ::WidgetsInc::Types::String50.create_unsafe(:address_line_1).("4321 Pine St."),
          address_line_2: None(),
          address_line_3: None(),
          address_line_4: None(),
          city: ::WidgetsInc::Types::String50.create_unsafe(:city).("AnotherCity"),
          zip_code: ::WidgetsInc::Types::ZipCode.create_unsafe(:zip_code).("67890"),
        )

        expected_order_line_1 = ::WidgetsInc::Types::ValidatedOrderLine.new(
          order_line_id: ::WidgetsInc::Types::OrderLineId.create_unsafe(:order_line_id).("1"),
          product_code: ::WidgetsInc::Types::WidgetCode.create_unsafe(:product_code).("W7639"),
          quantity: ::WidgetsInc::Types::UnitQuantity.create_unsafe(:quantity).(10),
        )

        expected_order_line_2 = ::WidgetsInc::Types::ValidatedOrderLine.new(
          order_line_id: ::WidgetsInc::Types::OrderLineId.create_unsafe(:order_line_id).("2"),
          product_code: ::WidgetsInc::Types::GizmoCode.create_unsafe(:product_code).("G6548"),
          quantity: ::WidgetsInc::Types::KilogramQuantity.create_unsafe(:quantity).(14.2),
        )

        expected = ::WidgetsInc::Types::ValidatedOrder.new(
          order_id: ::WidgetsInc::Types::OrderId.create_unsafe(:order_id).("987654321"),
          customer_info: expected_customer_info,
          shipping_address: expected_shipping_address,
          billing_address: expected_billing_address,
          lines: [expected_order_line_1, expected_order_line_2]
        )

        expect(actual).to eq(Success(expected))
      end
    end
  end
end
