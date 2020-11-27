module WidgetsInc
  module Types
    module ProductCode
      class << self
        def type
          ::WidgetsInc::Types.Instance(::WidgetsInc::Types::WidgetCode) | ::WidgetsInc::Types.Instance(::WidgetsInc::Types::GizmoCode)
        end

        def create(field_name)
          -> (value) do
            schema = Dry::Schema.Params do
              required(:value).filled(:string)
            end

            ::WidgetsInc::Util::ConstrainedType.validate_schema.(schema, field_name, value)
              .bind do |value|
              if value.start_with?("W")
                ::WidgetsInc::Types::WidgetCode.create(field_name).(value)
              elsif value.start_with?("G")
                ::WidgetsInc::Types::GizmoCode.create(field_name).(value)
              else
                # TODO
              end
            end
          end
        end
      end
    end
  end
end