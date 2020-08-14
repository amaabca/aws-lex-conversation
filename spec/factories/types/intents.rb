# frozen_string_literal: true

FactoryBot.define do
  factory(
    :current_intent,
    class: Aws::Lex::Conversation::Type::Intent
  ) do
    name { 'TestIntent' }
    raw_slots { { resolvable: 'one two', unresolvable: 'value', empty: nil } }
    slot_details do
      {
        resolvable: Aws::Lex::Conversation::Type::SlotDetail.new(
          original_value: 'one. two.',
          resolutions: [
            Aws::Lex::Conversation::Type::SlotResolution.new(value: '12')
          ]
        ),
        unresolvable: Aws::Lex::Conversation::Type::SlotDetail.new(
          original_value: 'value',
          resolutions: []
        )
      }
    end
    confirmation_status { Aws::Lex::Conversation::Type::ConfirmationStatus.new('None') }

    initialize_with do
      new(
        name: name,
        raw_slots: raw_slots,
        slot_details: slot_details,
        confirmation_status: confirmation_status
      )
    end
  end
end
