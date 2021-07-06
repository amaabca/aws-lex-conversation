# frozen_string_literal: true

FactoryBot.define do
  factory(
    :message,
    class: Aws::Lex::Conversation::Type::Message
  ) do
    content { 'Testing' }
    content_type { build(:content_type) }

    initialize_with do
      new(
        content: content,
        content_type: content_type
      )
    end
  end
end

# required :confirmation_state
# optional :kendra_response
# required :name
# required :raw_slots, from: :slots, virtual: true
# required :state
# optional :originating_request_id