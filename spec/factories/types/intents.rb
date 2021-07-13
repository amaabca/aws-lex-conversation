# frozen_string_literal: true

FactoryBot.define do
  factory(
    :current_intent,
    class: Aws::Lex::Conversation::Type::Intent
  ) do
    name { 'TestIntent' }
    raw_slots { { resolvable: 'one two', unresolvable: 'value', empty: nil } }
    confirmation_state { Aws::Lex::Conversation::Type::ConfirmationState.new('None') }

    initialize_with do
      new(
        name: name,
        raw_slots: raw_slots,
        confirmation_state: confirmation_state
      )
    end
  end
end
