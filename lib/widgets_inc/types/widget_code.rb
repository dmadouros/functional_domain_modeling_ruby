# typed: strict
module WidgetsInc
  module Types
    class WidgetCode < ::WidgetsInc::SimpleType
      class << self
        extend T::Sig

        sig {params(field_name: Symbol).returns(T.proc.params(value: String).returns(WidgetCode))}
        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_like.(field_name, /W\d{4}/, value)
              .fmap { |value| new(value: value) }
          end
        end
      end
    end
  end
end