# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Support
        class Inflector
          attr_accessor :input

          def initialize(input)
            self.input = input.to_s
          end

          def to_snake_case
            # shamelessly borrowed from ActiveSupport
            input
              .gsub(/::/, '/')
              .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
              .gsub(/([a-z\d])([A-Z])/, '\1_\2')
              .tr('-', '_')
              .gsub(/\W/, '_')
              .downcase
          end

          def to_camel_case(style = :lower)
            parts = input.split('_')
            first = parts.shift
            rest = parts.map(&:capitalize)

            case style
            when :lower
              rest.unshift(first).join
            when :upper
              rest.unshift(first.capitalize).join
            else
              raise ArgumentError, "invalid option: `#{style.inspect}`"
            end
          end
        end
      end
    end
  end
end
