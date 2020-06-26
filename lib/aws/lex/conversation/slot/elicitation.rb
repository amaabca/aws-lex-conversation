# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Slot
        class Elicitation
          attr_accessor :name, :elicit, :message, :follow_up_message,
                        :content_type, :fallback, :maximum_elicitations,
                        :conversation

          def initialize(opts = {})
            self.name = opts.fetch(:name)
            self.elicit = opts.fetch(:elicit) { ->(_c) { true } }
            self.message = opts.fetch(:message)
            self.follow_up_message = opts.fetch(:follow_up_message) { opts.fetch(:message) }
            self.content_type = opts.fetch(:content_type) do
              Aws::Lex::Conversation::Type::Message::ContentType.new('PlainText')
            end
            self.fallback = opts.fetch(:fallback) { ->(_c) {} }
            self.maximum_elicitations = opts.fetch(:maximum_elicitations) { 0 }
          end

          def elicit!
            return fallback.call(conversation) if maximum_elicitations?

            increment_slot_elicitations!
            conversation.elicit_slot(
              slot_to_elicit: name,
              message: {
                contentType: content_type,
                content: elicitation_content
              }
            )
          end

          def elicit?
            elicit.call(conversation) && !slot.filled?
          end

          private

          def slot
            conversation.slots[name.to_sym]
          end

          def elicitation_content
            first_elicitation? ? message : follow_up_message
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
