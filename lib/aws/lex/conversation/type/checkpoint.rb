# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Checkpoint
          include Base

          required :dialog_action_type
          required :intent_name

          optional :label
          optional :fulfillment_state
          optional :slot_to_elicit

          coerce(
            dialog_action_type: DialogActionType,
            fulfillment_state: FulfillmentState
          )

          # rubocop:disable Metrics/MethodLength
          def restore(conversation, opts = {})
            case dialog_action_type.raw
            when 'Close'
              conversation.close(
                fulfillment_state: opts.fetch(:fulfillment_state) { fulfillment_state },
                messages: opts.fetch(:messages)
              )
            when 'ConfirmIntent'
              conversation.confirm_intent(
                intent_name: intent_name,
                messages: opts.fetch(:messages)
              )
            when 'Delegate'
              conversation.delegate
            when 'ElicitIntent'
              conversation.elicit_intent(
                messages: opts.fetch(:messages)
              )
            when 'ElicitSlot'
              conversation.elicit_slot(
                intent_name: intent_name,
                messages: opts.fetch(:messages),
                slot_to_elicit: slot_to_elicit
              )
            else
              raise ArgumentError, "invalid DialogActionType: `#{dialog_action_type.raw}`"
            end
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
