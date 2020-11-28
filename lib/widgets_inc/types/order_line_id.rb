# typed: false
module WidgetsInc
  module Types
    class OrderLineId < ::WidgetsInc::SimpleType
      class << self
        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_string.(field_name, 50, value)
              .fmap { |value| new(value: value) }
          end
        end
      end
    end
  end
end