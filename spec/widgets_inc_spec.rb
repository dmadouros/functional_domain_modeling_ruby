RSpec.describe WidgetsInc do
  include ::Dry::Monads[:result, :maybe]

  describe ".to_customer_info" do
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

    context "when all fields valid" do
      it "returns customer_info result" do
        actual = ::WidgetsInc.to_customer_info.(unvalidated_customer_info)

        expected = ::WidgetsInc::Types::CustomerInfo.new(
          name: ::WidgetsInc::Types::PersonalName.new(
            first_name: "Bilbo",
            last_name: "Baggins",
          ),
          email_address: "bilbo.baggins@example.com"
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

    context "when all fields valid" do
      it "returns address result" do
        check_address_exists = ->(unvalidated_address) { unvalidated_address}

        actual = WidgetsInc.to_address.(check_address_exists, unvalidated_address)

        expected = ::WidgetsInc::Types::Address.new(
          address_line_1: "1234 Main St.",
          address_line_2: Some("Unit 1A"),
          address_line_3: None(),
          address_line_4: None(),
          city: "AnyCity",
          zip_code: "12345",
        )
        expect(actual).to eq(Success(expected))
      end
    end
  end
end
