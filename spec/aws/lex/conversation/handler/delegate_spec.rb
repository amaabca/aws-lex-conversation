# frozen_string_literal: true

describe Aws::Lex::Conversation::Handler::V1::Delegate do
  let(:lambda_context) { build(:context) }
  let(:event) { parse_fixture('events/intents/v1/all_properties.json') }
  let(:conversation) { Aws::Lex::V1::Conversation.new(event: event, context: lambda_context) }

  describe '#response' do
    let(:response) { subject.response(conversation) }

    it 'returns a delegate response' do
      expect(response.dig(:dialogAction, :type)).to eq('Delegate')
    end

    it 'returns the resolved slot values' do
      expect(response.dig(:dialogAction, :slots)).to eq(
        'slot-one': 'one',
        'slot-two': 'two'
      )
    end
  end
end
