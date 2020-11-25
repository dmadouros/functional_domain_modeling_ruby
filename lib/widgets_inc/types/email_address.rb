module WidgetsInc
  module Types
    module EmailAddress
      class << self
        def type
          WidgetsInc::Types::Strict::String.constrained(format: pattern)
        end

        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_like.(field_name, pattern, value)
          end
        end

        private

        def pattern
          /.+@.+/
        end
      end
    end
  end
end