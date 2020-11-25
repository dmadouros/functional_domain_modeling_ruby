RSpec.describe WidgetsInc do
  include ::Dry::Monads[:result]

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
        actual = WidgetsInc.to_customer_info.(unvalidated_customer_info)

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
end
