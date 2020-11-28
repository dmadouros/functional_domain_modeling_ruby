# typed: false
module WidgetsInc
  module Types
    class GizmoCode < ::WidgetsInc::SimpleType
      class << self
        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_like.(field_name, /G\d{3}/, value)
              .fmap { |value| new(value: value) }
          end
        end
      end
    end
  end
end