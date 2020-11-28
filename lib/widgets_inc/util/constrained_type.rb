# typed: ignore
module WidgetsInc
  module Util
    module ConstrainedType
      extend ::Dry::Monads[:result, :maybe]

      class << self
        def create_string
          -> (field_name, max_length, value) do
            schema = Dry::Schema.Params do
              required(:value).filled(:string, max_size?: max_length)
            end

            validate_schema.(schema, field_name, value)
          end
        end

        def create_string_option
          -> (field_name, max_length, value) do
            schema = Dry::Schema.Params do
              required(:value).maybe(:string, max_size?: max_length)
            end

            validate_schema.(schema, field_name, value)
              .fmap { |r| Maybe(r) }
          end
        end

        def create_like
          -> (field_name, pattern, value) do
            schema = Dry::Schema.Params do
              required(:value).filled(:string, format?: pattern)
            end

            validate_schema.(schema, field_name, value)
          end
        end

        def create_int
          -> (field_name, min, max, value) do
            schema = Dry::Schema.Params do
              required(:value).filled(:int?, gteq?: min, lteq?: max)
            end

            validate_schema.(schema, field_name, value)
          end
        end

        def create_float
          -> (field_name, min, max, value) do
            schema = Dry::Schema.Params do
              required(:value).filled(:float?, gteq?: min, lteq?: max)
            end

            validate_schema.(schema, field_name, value)
          end
        end

        def validate_schema
          -> (schema, field_name, value) do
            schema.call(value: value)
              .to_monad
              .fmap { |r| r.to_h[:value] }
              .or { |r|
                Failure(r.errors.to_h[:value].map { |e| "#{field_name}: #{e}" })
              }
          end
        end
      end
    end
  end
end