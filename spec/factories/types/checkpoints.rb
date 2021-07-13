# frozen_string_literal: true

FactoryBot.define do
  factory(
    :checkpoint,
    class: Aws::Lex::Conversation::Type::Checkpoint
  ) do
    intent { build(:current_intent, name: 'Lex_Intent_Echo') }
    label { 'myCheckpoint' }
    slot_to_elicit { nil }

    trait :close do
      dialog_action_type { Aws::Lex::Conversation::Type::DialogActionType.new('Close') }
      fulfillment_state { Aws::Lex::Conversation::Type::FulfillmentState.new('Failed') }
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
      slot_to_elicit { 'HasACat' }
    end

    trait :invalid do
      dialog_action_type { Aws::Lex::Conversation::Type::DialogActionType.new('Invalid') }
    end

    initialize_with do
      new(
        label: label,
        dialog_action_type: dialog_action_type,
        intent: intent,
        slot_to_elicit: slot_to_elicit
      )
    end
  end
end
