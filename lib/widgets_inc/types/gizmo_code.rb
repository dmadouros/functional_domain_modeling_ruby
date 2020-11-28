# typed: strict
module WidgetsInc
  module Types
    class GizmoCode < ::WidgetsInc::SimpleType
      class << self
        extend T::Sig

        sig {params(field_name: Symbol).returns(T.proc.params(value: String).returns(GizmoCode))}
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