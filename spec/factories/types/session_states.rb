# frozen_string_literal: true

FactoryBot.define do
  factory(
    :session_state,
    class: Aws::Lex::Conversation::Type::SessionState
  ) do
    intent { build(:current_intent) }

    initialize_with do
      new(
        intent: intent
      )
    end
  end
end
