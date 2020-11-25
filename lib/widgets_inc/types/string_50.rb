module WidgetsInc
  module Types
    module String50
      class << self
        def type
          ::WidgetsInc::Types::Strict::String.constrained(max_size: 50, filled: true)
        end

        def create(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_string.(field_name, 50, value)
          end
        end

        def create_option(field_name)
          -> (value) do
            ::WidgetsInc::Util::ConstrainedType.create_string_option.(field_name, 50, value)
          end
        end
      end
    end
  end
end