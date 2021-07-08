# frozen_string_literal: true

FactoryBot.define do
  factory(
    :message,
    class: Aws::Lex::Conversation::Type::Message
  ) do
    content { 'Testing' }
    content_type { build(:content_type) }

    trait :image_response_card do
      content_type { build(:content_type, :image_response_card) }
      image_response_card { build(:response_card) }
    end

    initialize_with do
      new(
        content: content,
        content_type: content_type
      )
    end
  end
end
