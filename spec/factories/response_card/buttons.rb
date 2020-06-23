# frozen_string_literal: true

FactoryBot.define do
  factory(
    :response_card_button,
    class: Aws::Lex::Conversation::Type::ResponseCard::Button
  ) do
    text { 'Submit' }
    value { 'true' }

    initialize_with do
      new(
        text: text,
        value: value
      )
    end
  end
end
