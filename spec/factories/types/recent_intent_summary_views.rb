# frozen_string_literal: true

FactoryBot.define do
  factory(
    :recent_intent_summary_view,
    class: Aws::Lex::Conversation::Type::RecentIntentSummaryView
  ) do
    intent_name { 'TestIntent' }
    slots { {} }
    confirmation_status { Aws::Lex::Conversation::Type::ConfirmationStatus.new('None') }
    checkpoint_label { 'myCheckpoint' }
    fulfillment_state { nil }
    slot_to_elicit { nil }

    trait :close do
      dialog_action_type { Aws::Lex::Conversation::Type::DialogActionType.new('Close') }
    end

    trait :confirm_intent do
      dialog_action_type { Aws::Lex::Conversation::Type::DialogActionType.new('ConfirmIntent') }
    end

    trait :delegate do
      dialog_action_type { Aws::Lex::Conversation::Type::DialogActionType.new('Delegate') }
    end

    trait :elicit_intent do
      dialog_action_type { Aws::Lex::Conversation::Type::DialogActionType.new('ElicitIntent') }
    end

    trait :elicit_slot do
      dialog_action_type { Aws::Lex::Conversation::Type::DialogActionType.new('ElicitSlot') }
      slots { { one: nil } }
      slot_to_elicit { 'one' }
    end

    trait :invalid do
      dialog_action_type { Aws::Lex::Conversation::Type::DialogActionType.new('Invalid') }
    end

    initialize_with do
      new(
        checkpoint_label: checkpoint_label,
        confirmation_status: confirmation_status,
        dialog_action_type: dialog_action_type,
        fulfillment_state: fulfillment_state,
        intent_name: intent_name,
        slots: slots,
        slot_to_elicit: slot_to_elicit
      )
    end
  end
end
