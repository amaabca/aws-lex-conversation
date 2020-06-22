# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class RecentIntentSummaryView
          include Base

          required :intent_name
          required :slots
          required :confirmation_status
          required :dialog_action_type
          required :slot_to_elicit

          optional :fulfillment_state
          optional :checkpoint_label

          coerce(
            slots: symbolize_hash!,
            confirmation_status: ConfirmationStatus,
            dialog_action_type: DialogActionType,
            fulfillment_state: FulfillmentState
          )
        end
      end
    end
  end
end
