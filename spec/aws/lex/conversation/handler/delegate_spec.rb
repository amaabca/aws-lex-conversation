# frozen_string_literal: true

describe Aws::Lex::Conversation::Handler::Delegate do
  let(:lambda_context) { build(:context) }
  let(:event) { parse_fixture('events/intents/basic.json') }
  let(:conversation) { Aws::Lex::Conversation.new(event: event, context: lambda_context) }

  describe '#response' do
    let(:response) { subject.response(conversation) }

    it 'returns a delegate response' do
      expect(response).to have_action('Delegate')
    end
  end
end
