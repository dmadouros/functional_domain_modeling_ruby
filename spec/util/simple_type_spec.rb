module WidgetsInc
  module Util
    RSpec.describe SimpleType do
      it "requires subclasses to implement .create" do
        expect { SimpleType.create(:field_name) }.to raise_error(NotImplementedError)
      end

      it "makes .new private" do
        expect { SimpleType.new }.to raise_error(NoMethodError)
      end

      describe "#deconstruct_keys" do
        it "allows for pattern matching on value" do
          class SimpleType::Test < SimpleType
            def self.create(field_name)
              new(value: field_name)
            end
          end

          result = SimpleType::Test.create(:hello)

          case result
          in SimpleType(value:)
            expect(value).to eq(:hello)
          end
        end
      end

      describe "#hash" do
        it "returns same hash for the same value" do
          class SimpleType::Test < SimpleType
            def self.create(field_name)
              new(value: field_name)
            end
          end

          result_1 = SimpleType::Test.create(:hello)
          result_2 = SimpleType::Test.create(:hello)

          expect(result_1.hash).to eq(result_2.hash)
        end
      end

      describe "#==" do
        it "returns true for the same value" do
          class SimpleType::Test < SimpleType
            def self.create(field_name)
              new(value: field_name)
            end
          end

          result_1 = SimpleType::Test.create(:hello)
          result_2 = SimpleType::Test.create(:hello)

          expect(result_1).to eq(result_2)
        end

        it "returns false for the same value, different class" do
          class SimpleType::Test < SimpleType
            def self.create(field_name)
              new(value: field_name)
            end
          end

          class SimpleType::Test2 < SimpleType
            def self.create(field_name)
              new(value: field_name)
            end
          end

          result_1 = SimpleType::Test.create(:hello)
          result_2 = SimpleType::Test2.create(:hello)

          expect(result_1).not_to eq(result_2)
        end
      end
    end
  end
end