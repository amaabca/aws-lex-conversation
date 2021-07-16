# frozen_string_literal: true

describe Aws::Lex::Conversation::Handler::Echo do
  let(:lambda_context) { build(:context) }
  let(:event) { parse_fixture('events/intents/basic.json') }
  let(:conversation) { Aws::Lex::Conversation.new(event: event, context: lambda_context) }

  describe '#response' do
    let(:response) { subject.response(conversation) }
    let(:messages) { response[:messages].map { |m| m[:content] } }

    it 'returns a Close response' do
      expect(response.dig(:sessionState, :dialogAction, :type)).to eq('Close')
    end

    it 'returns a message of the input transcript' do
      expect(messages).to include(event['inputTranscript'])
    end
  end
end
