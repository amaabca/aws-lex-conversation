# frozen_string_literal: true

class SlotElicitationHandler < Aws::Lex::Conversation::Handler::Echo
  include Aws::Lex::Conversation::Support::Mixins::SlotElicitation

  slot name: 'one',
       elicit: ->(conversation) { conversation.session[:elicit_slot] == true },
       message: 'What is your favorite color?',
       follow_up_message: 'Sorry, I did not understand you. What is your favorite color?',
       fallback: ->(conversation) do
         conversation.close(
           fulfillment_state: 'Failed',
           message: {
             contentType: Aws::Lex::Conversation::Type::Message::ContentType.new('PlainText'),
             content: 'Failed'
           }
         )
       end,
       maximum_elicitations: 2
end
