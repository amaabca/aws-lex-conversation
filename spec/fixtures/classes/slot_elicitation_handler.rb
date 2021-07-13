# frozen_string_literal: true

class SlotElicitationHandler < Aws::Lex::Conversation::Handler::Echo
  include Aws::Lex::Conversation::Support::Mixins::SlotElicitation

  slot name: 'HasACat',
       elicit: ->(conversation) { conversation.session[:elicit_slot] == true },
       message: 'Do you have a cat?',
       follow_up_message: 'Sorry, I did not understand you. Do you have a cat?',
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
