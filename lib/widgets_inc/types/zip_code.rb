module WidgetsInc
  module Types
    module ZipCode
      class << self
        def type
          ::WidgetsInc::Types::Strict::String.constrained(format: pattern, filled: true)
        end

        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_like.(field_name, pattern, value)
          end
        end

        private

        def pattern
          /\d{5}/
        end
      end
    end
  end
end