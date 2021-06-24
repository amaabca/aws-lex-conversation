# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class RecentIntentSummaryView
          include Base

          required :intent_name
          required :slots
          required :confirmation_state
          required :dialog_action_type

          optional :checkpoint_label
          optional :fulfillment_state
          optional :slot_to_elicit

          coerce(
            slots: symbolize_hash!,
            confirmation_status: ConfirmationState,
            dialog_action_type: DialogActionType,
            fulfillment_state: FulfillmentState
          )

          # TODO: how do we handle this?

          # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          def restore(conversation, opts = {})
            case dialog_action_type.raw
            when 'Close'
              conversation.close(
                fulfillment_state: opts.fetch(:fulfillment_state) { fulfillment_state },
                message: opts.fetch(:message),
                response_card: opts[:response_card]
              )
            when 'ConfirmIntent'
              conversation.confirm_intent(
                intent_name: intent_name,
                message: opts.fetch(:message),
                response_card: opts[:response_card],
                slots: slots
              )
            when 'Delegate'
              conversation.delegate(
                kendra_query_request_payload: opts[:kendra_query_request_payload],
                kendra_query_filter_string: opts[:kendra_query_filter_string],
                slots: slots
              )
            when 'ElicitIntent'
              conversation.elicit_intent(
                message: opts.fetch(:message),
                response_card: opts[:response_card]
              )
            when 'ElicitSlot'
              conversation.elicit_slot(
                intent_name: intent_name,
                message: opts.fetch(:message),
                response_card: opts[:response_card],
                slots: slots,
                slot_to_elicit: slot_to_elicit
              )
            else
              raise ArgumentError, "invalid DialogActionType: `#{dialog_action_type.raw}`"
            end
          end
          # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
        end
      end
    end
  end
end
