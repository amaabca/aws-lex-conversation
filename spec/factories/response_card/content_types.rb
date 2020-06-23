# frozen_string_literal: true

FactoryBot.define do
  factory(
    :response_card_content_type,
    class: Aws::Lex::Conversation::Type::ResponseCard::ContentType
  ) do
    raw { 'application/vnd.amazonaws.card.generic' }

    initialize_with { new(raw) }
  end
end
