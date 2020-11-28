# typed: false
module WidgetsInc
  module Types
    class ZipCode < ::WidgetsInc::SimpleType
      class << self
        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_like.(field_name, /\d{5}/, value)
              .fmap { |value| new(value: value) }
          end
        end
      end
    end
  end
end