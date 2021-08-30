# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Slot
        class Elicitation
          attr_accessor :name, :elicit, :messages, :follow_up_messages,
                        :fallback, :maximum_elicitations, :conversation

          def initialize(opts = {})
            self.name = opts.fetch(:name)
            self.elicit = opts.fetch(:elicit) { ->(_c) { true } }
            self.messages = opts.fetch(:messages)
            self.follow_up_messages = opts.fetch(:follow_up_messages) { opts.fetch(:messages) }
            self.fallback = opts[:fallback]
            self.maximum_elicitations = opts.fetch(:maximum_elicitations) { 0 }
          end

          def elicit!
            return false unless elicit?
            return fallback.call(conversation) if maximum_elicitations?

            increment_slot_elicitations!
            conversation.elicit_slot(
              slot_to_elicit: name,
              messages: elicitation_messages
            )
          end

          def elicit?
            return false if maximum_elicitations? && fallback.nil?

            elicit.call(conversation) && !slot.filled?
          end

          private

          def slot
            conversation.slots[name.to_sym]
          end

          def elicitation_messages
            first_elicitation? ? compose_messages(messages) : compose_messages(follow_up_messages)
          end

          def compose_messages(msg)
            msg.is_a?(Proc) ? msg.call(conversation) : msg
          end

          def increment_slot_elicitations!
            conversation.session[session_key] = elicitation_attempts + 1
          end

          def maximum_elicitations?
            return false if maximum_elicitations.zero?

            elicitation_attempts > maximum_elicitations
          end

          def first_elicitation?
            elicitation_attempts == 1
          end

          def session_key
            :"SlotElicitations_#{name}"
          end

          def elicitation_attempts
            conversation.session[session_key].to_i
          end
        end
      end
    end
  end
end
