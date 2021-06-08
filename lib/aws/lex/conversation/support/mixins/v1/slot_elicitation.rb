# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Support
        module Mixins
          module V1
            module SlotElicitation
              def self.included(base)
                base.include(InstanceMethods)
                base.extend(ClassMethods)
                base.attr_accessor(:conversation)
                base.class_attribute(:slots_to_elicit)
              end

              module InstanceMethods
                def elicit_slots!
                  slot_elicitor.elicit!
                end

                def slots_elicitable?
                  slot_elicitor.elicit?
                end

                private

                def slot_elicitor
                  @slot_elicitor ||= Aws::Lex::Conversation::Slot::V1::Elicitor.new(
                    conversation: conversation,
                    elicitations: self.class.slots_to_elicit
                  )
                end
              end

              module ClassMethods
                def slot(opts = {})
                  self.slots_to_elicit ||= []
                  self.slots_to_elicit.push(
                    Aws::Lex::Conversation::Slot::V1::Elicitation.new(opts)
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
