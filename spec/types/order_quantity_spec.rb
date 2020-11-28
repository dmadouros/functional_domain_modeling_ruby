# typed: false
module WidgetsInc
  module Types
    RSpec.describe OrderQuantity do
      include ::Dry::Monads[:result]

      describe ".create" do
        context "when product code is for GizmoCode" do
          it "returns valid KilogramQuantity" do
            product_code = GizmoCode.create_unsafe(:product_code).("G123")

            result = OrderQuantity.create(:order_quantity).(product_code, 5.0)

            expect(result).to eq(Success(KilogramQuantity.create_unsafe(:order_quantity).(5.0)))
          end
        end

        context "when value is for UnitQuantity" do
          it "returns valid UnitQuantity" do
            product_code = WidgetCode.create_unsafe(:product_code).("W1234")

            result = OrderQuantity.create(:order_quantity).(product_code, 5)

            expect(result).to eq(Success(UnitQuantity.create_unsafe(:order_quantity).(5)))
          end
        end
      end
    end
  end
end