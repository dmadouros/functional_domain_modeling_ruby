# typed: true
module WidgetsInc
  module Types
    class ZipCode < ::WidgetsInc::SimpleType
      class << self
        extend T::Sig

        sig {params(field_name: Symbol).returns(T.proc.params(value: String).returns(ZipCode))}
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