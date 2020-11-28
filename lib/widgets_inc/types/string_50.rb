# typed: strict
module WidgetsInc
  module Types
    class String50 < ::WidgetsInc::SimpleType
      class << self
      extend T::Sig

        sig {params(field_name: Symbol).returns(T.proc.params(value: String).returns(String50))}
        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_string.(field_name, 50, value)
              .fmap { |value| new(value: value) }
          end
        end

        sig {params(field_name: Symbol).returns(T.proc.params(value: String).returns(String50))}
        def create_option(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_string_option.(field_name, 50, value)
              .fmap { |value|
                value.fmap { new(value: value) }
              }
          end
        end

        sig {params(field_name: Symbol).returns(Proc)}
        def create_option_unsafe(field_name)
          -> (*args) {
            create_option(field_name).(*args).value!
          }
        end
      end
    end
  end
end