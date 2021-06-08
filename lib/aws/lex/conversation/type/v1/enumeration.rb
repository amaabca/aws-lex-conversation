# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          module Enumeration
            def self.included(base)
              base.extend(ClassMethods)
              base.include(InstanceMethods)
              base.attr_accessor(:raw)
              base.class_eval do
                def initialize(raw)
                  self.raw = raw
                end
              end
            end

            module InstanceMethods
              def to_lex
                raw # maintain original casing
              end
            end

            module ClassMethods
              def enumeration(value)
                enumerations << value
                snake_case = Support::Inflector.new(value).to_snake_case
                class_eval(
                  "def #{snake_case}?; raw.casecmp('#{value}').zero?; end",
                  __FILE__,
                  __LINE__ - 2
                )
              end

              def enumerations
                @enumerations ||= []
              end
            end
          end
        end
      end
    end
  end
end
