# typed: ignore
module WidgetsInc
  module Types
    RSpec.describe KilogramQuantity do
      include ::Dry::Monads[:result]

      describe ".create" do
        context "when value is just right" do
          it "returns valid unit_quantity" do
            result = KilogramQuantity.create(:order_quantity).(5.0)

            expect(result).to be_instance_of(::Dry::Monads::Success)
            case result.value!
            in KilogramQuantity(value:)
              expect(value).to eq(5.0)
            end
          end
        end

        context "when value is not integer" do
          it "returns validation error" do
            result = KilogramQuantity.create(:order_quantity).("5.0")

            expect(result).to eq(Failure(["order_quantity: must be a float"]))
          end
        end

        context "when value is less than minimum" do
          it "returns validation error" do
            result = KilogramQuantity.create(:order_quantity).(0.4)

            expect(result).to eq(Failure(["order_quantity: must be greater than or equal to 0.5"]))
          end
        end

        context "when value is more than minimum" do
          it "returns validation error" do
            result = KilogramQuantity.create(:order_quantity).(100.1)

            expect(result).to eq(Failure(["order_quantity: must be less than or equal to 100.0"]))
          end
        end
      end
    end
  end
end