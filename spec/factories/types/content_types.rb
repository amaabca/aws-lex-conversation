# frozen_string_literal: true

FactoryBot.define do
  factory(
    :content_type,
    class: Aws::Lex::Conversation::Type::Message::ContentType
  ) do
    type { 'PlainText' }

    trait :image_response_card do
      type { 'ImageResponseCard' }
    end

    initialize_with do
      new(type)
    end
  end
end
