module WidgetsInc
  module Types
    class UnitQuantity < ::WidgetsInc::SimpleType
      class << self
        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_int.(field_name, 1, 1000, value)
              .fmap { |value| new(value: value) }
          end
        end
      end
    end
  end
end