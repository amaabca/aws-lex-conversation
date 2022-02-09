# frozen_string_literal: true

FactoryBot.define do
  factory(
    :current_intent,
    class: Aws::Lex::Conversation::Type::Intent
  ) do
    name { 'TestIntent' }
    raw_slots do
      {
        HasACat: {
          shape: 'Scalar',
          value: {
            originalValue: 'NO',
            resolvedValues: [
              'NO'
            ],
            interpretedValue: 'NO'
          }
        },
        LivesInAHouse: {
          shape: 'Scalar',
          value: {
            originalValue: 'YES',
            resolvedValues: [
              'YES'
            ],
            interpretedValue: 'YES'
          }
        }
      }
    end
    confirmation_state { Aws::Lex::Conversation::Type::ConfirmationState.new('None') }
    state { 'InProgress' }

    initialize_with do
      new(
        name: name,
        raw_slots: raw_slots,
        confirmation_state: confirmation_state
      )
    end
  end
end
