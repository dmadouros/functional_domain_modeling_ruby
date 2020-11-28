# typed: ignore
module WidgetsInc
  module Types
    RSpec.describe UnitQuantity do
      include ::Dry::Monads[:result]

      describe ".create" do
        context "when value is just right" do
          it "returns valid unit_quantity" do
            result = UnitQuantity.create(:order_quantity).(5)

            expect(result).to be_instance_of(::Dry::Monads::Success)
            case result.value!
            in UnitQuantity(value:)
              expect(value).to eq(5)
            end
          end
        end

        context "when value is not integer" do
          it "returns validation error" do
            result = UnitQuantity.create(:order_quantity).("5")

            expect(result).to eq(Failure(["order_quantity: must be an integer"]))
          end
        end

        context "when value is less than minimum" do
          it "returns validation error" do
            result = UnitQuantity.create(:order_quantity).(0)

            expect(result).to eq(Failure(["order_quantity: must be greater than or equal to 1"]))
          end
        end

        context "when value is more than minimum" do
          it "returns validation error" do
            result = UnitQuantity.create(:order_quantity).(1001)

            expect(result).to eq(Failure(["order_quantity: must be less than or equal to 1000"]))
          end
        end
      end
    end
  end
end