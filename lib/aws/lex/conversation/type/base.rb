module Aws
  module Lex
    class Conversation
      module Type
        module Base
          def self.included(base)
            base.include(Shrink::Wrap)
            base.include(InstanceMethods)
            base.extend(ClassMethods)
            base.transform(Shrink::Wrap::Transformer::Symbolize)
            base.class_eval do
              def initialize(opts = {})
                assign_attributes!(opts)
              end
            end
          end

          module InstanceMethods
            def assign_attributes!(opts = {})
              self.class.attributes.each do |attribute|
                instance_variable_set("@#{attribute}", opts[attribute])
              end
            end

            def to_lex
              self.class.attributes.each_with_object({}) do |attribute, hash|
                value = transform_to_lex(instance_variable_get("@#{attribute}"))
                hash[self.class.mapping.fetch(attribute)] = value
              end
            end

            private

            def transform_to_lex(value)
              case value
              when Hash
                value.each_with_object({}) do |(key, val), hash|
                  hash[key.to_sym] = transform_to_lex(val)
                end
              when Array
                value.map { |v| transform_to_lex(v) }
              else
                if value.respond_to?(:to_lex)
                  value.to_lex
                else
                  value
                end
              end
            end
          end

          module ClassMethods
            def symbolize_hash!
              ->(v) { v.transform_keys(&:to_sym) }
            end

            def required(attribute, opts = {})
              property(attribute, opts.merge(allow_nil: false))
            end

            def optional(attribute, opts = {})
              property(attribute, opts.merge(allow_nil: true))
            end

            def property(attribute, opts = {})
              from = opts.fetch(:from) do
                Support::Inflector.new(attribute).to_camel_case.to_sym
              end
              params = { from: from }.merge(opts)

              attr_accessor(attribute)
              mapping[attribute] = from
              translate(attribute => params)
            end

            def attributes
              @attributes ||= mapping.keys
            end

            def mapping
              @mapping ||= {}
            end
          end
        end
      end
    end
  end
end
