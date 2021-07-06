# frozen_string_literal: true

FactoryBot.define do
  factory(
    :content_type,
    class: Aws::Lex::Conversation::Type::Message::ContentType
  ) do
    type { 'PlainText' }

    initialize_with do
      new(type)
    end
  end
end

# required :confirmation_state
# optional :kendra_response
# required :name
# required :raw_slots, from: :slots, virtual: true
# required :state
# optional :originating_request_id