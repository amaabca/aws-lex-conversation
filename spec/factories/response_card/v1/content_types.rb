# frozen_string_literal: true

FactoryBot.define do
  factory(
    :response_card_content_type_v1,
    class: Aws::Lex::Conversation::Type::V1::ResponseCard::ContentType
  ) do
    raw { 'application/vnd.amazonaws.card.generic' }

    initialize_with { new(raw) }
  end
end
