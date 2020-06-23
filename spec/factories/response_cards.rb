# frozen_string_literal: true

FactoryBot.define do
  factory :response_card, class: Aws::Lex::Conversation::Type::ResponseCard do
    version { 1 }
    content_type { build(:response_card_content_type) }
    generic_attachments { build_list(:response_card_generic_attachment, 1) }

    initialize_with do
      new(
        version: version,
        content_type: content_type,
        generic_attachments: generic_attachments
      )
    end
  end
end
