# frozen_string_literal: true

FactoryBot.define do
  factory :response_card, class: Aws::Lex::Conversation::Type::ResponseCard do
    title { 'Title' }
    sub_title { 'Sub Title' }
    image_url { 'https://example.com/image.jpg' }
    buttons { build_list(:response_card_button, 1) }

    initialize_with do
      new(
        title: title,
        sub_title: sub_title,
        image_url: image_url,
        buttons: buttons
      )
    end
  end
end
