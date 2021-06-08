# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module Base
          def self.included(base)
            base.include(Shrink::Wrap)
            base.include(InstanceMethods)
            base.extend(ClassMethods)
            base.transform(Shrink::Wrap::Transformer::Symbolize, depth: 10)
            base.class_eval do
              def initialize(opts = {})
                assign_attributes!(opts)
              end
            end
          end

          module InstanceMethods
            def assign_attributes!(opts = {})
              attributes = self.class.attributes | self.class.virtual_attributes
              attributes.each do |attribute|
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
            def integer!(nilable: false)
              nilable ? ->(v) { v&.to_i } : ->(v) { v.to_i }
            end

            def float!(nilable: false)
              nilable ? ->(v) { v&.to_f } : ->(v) { v.to_f }
            end

            def symbolize_hash!
              ->(v) { v.transform_keys(&:to_sym) }
            end

            def computed_property(attribute, callable)
              mapping[attribute] = attribute
              attr_writer(attribute)

              # dynamically memoize the result
              define_method(attribute) do
                instance_variable_get("@#{attribute}") ||
                  instance_variable_set("@#{attribute}", callable.call(self))
              end
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

              if opts.fetch(:virtual) { false }
                virtual_attributes << attribute
              else
                mapping[attribute] = from
              end

              translate(attribute => params)
            end

            def attributes
              @attributes ||= mapping.keys
            end

            def virtual_attributes
              @virtual_attributes ||= []
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
