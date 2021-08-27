# frozen_string_literal: true

class SlotElicitationHandler < Aws::Lex::Conversation::Handler::Echo
  include Aws::Lex::Conversation::Support::Mixins::SlotElicitation

  slot name: 'HasACat',
       elicit: ->(conversation) { conversation.session[:elicit_slot] == true },
       messages: [
         Aws::Lex::Conversation::Type::Message.new(
           content: 'Do you have a cat?',
           content_type: 'PlainText'
         )
       ],
       follow_up_messages: [
         Aws::Lex::Conversation::Type::Message.new(
           content: 'Sorry, I did not understand you. Do you have a cat?',
           content_type: 'PlainText'
         )
       ],
       fallback: ->(conversation) do
         conversation.close(
           fulfillment_state: 'Failed',
           messages: [
             {
               contentType: Aws::Lex::Conversation::Type::Message::ContentType.new('PlainText'),
               content: 'Failed'
             }
           ]
         )
       end,
       maximum_elicitations: 2
end
