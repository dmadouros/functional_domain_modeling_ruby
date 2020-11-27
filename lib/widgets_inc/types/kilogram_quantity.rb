module WidgetsInc
  module Types
    class KilogramQuantity < ::WidgetsInc::SimpleType
      class << self
        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_float.(field_name, 0.5, 100.0, value)
              .fmap { |value| new(value: value) }
          end
        end
      end
    end
  end
end