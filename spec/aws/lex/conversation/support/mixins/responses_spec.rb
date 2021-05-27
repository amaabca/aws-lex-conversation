# frozen_string_literal: true

describe Aws::Lex::Conversation::Support::Mixins::Responses do
  let(:klass) { Struct.new(:lex, :pending_checkpoints).include(described_class) }
  let(:event) { parse_fixture('events/intents/all_properties.json') }
  let(:lex) { Aws::Lex::Conversation::Type::Event.shrink_wrap(event) }
  let(:response_card) { build(:response_card) }

  subject { klass.new(lex, nil) }

  describe '#close' do
    let(:response) do
      subject.close(
        fulfillment_state: 'Failed',
        message: { content: 'Test' },
        response_card: response_card
      )
    end

    it 'returns a close response' do
      expect(response.dig(:dialogAction, :type)).to eq('Close')
    end

    it 'returns the message in the response' do
      expect(response.dig(:dialogAction, :message)).to eq(content: 'Test')
    end

    it 'returns the response card in the response' do
      expect(response.dig(:dialogAction, :responseCard)).to eq(response_card.to_lex)
    end
  end

  describe '#confirm_intent' do
    let(:response) { subject.confirm_intent }

    it 'returns a ConfirmIntent response' do
      expect(response.dig(:dialogAction, :type)).to eq('ConfirmIntent')
    end

    it 'returns the intentName' do
      expect(response.dig(:dialogAction, :intentName)).to eq('intent-name')
    end

    it 'returns the slot values' do
      expect(response.dig(:dialogAction, :slots)).to eq(
        'slot-one': 'one',
        'slot-two': 'two'
      )
    end
  end

  describe '#delegate' do
    let(:response) { subject.delegate }

    it 'returns a Delegate response' do
      expect(response.dig(:dialogAction, :type)).to eq('Delegate')
    end

    it 'returns the slot values' do
      expect(response.dig(:dialogAction, :slots)).to eq(
        'slot-one': 'one',
        'slot-two': 'two'
      )
    end
  end

  describe '#elicit_intent' do
    let(:response) do
      subject.elicit_intent(
        message: { content: 'Try saying something else.' },
        response_card: response_card
      )
    end

    it 'returns an ElicitIntent repsonse' do
      expect(response.dig(:dialogAction, :type)).to eq('ElicitIntent')
    end

    it 'returns the message' do
      expect(response.dig(:dialogAction, :message)).to eq(
        content: 'Try saying something else.'
      )
    end

    it 'returns the response card' do
      expect(response.dig(:dialogAction, :responseCard)).to eq(response_card.to_lex)
    end
  end

  describe '#elicit_slot' do
    let(:response) do
      subject.elicit_slot(
        slot_to_elicit: 'one',
        message: { content: 'What is the first number?' },
        response_card: response_card
      )
    end

    it 'returns an ElicitSlot response' do
      expect(response.dig(:dialogAction, :type)).to eq('ElicitSlot')
    end

    it 'returns the intentName property' do
      expect(response.dig(:dialogAction, :intentName)).to eq('intent-name')
    end

    it 'returns the slot values' do
      expect(response.dig(:dialogAction, :slots)).to eq(
        'slot-one': 'one',
        'slot-two': 'two'
      )
    end

    it 'returns the slotToElicit property' do
      expect(response.dig(:dialogAction, :slotToElicit)).to eq('one')
    end

    it 'returns the message property' do
      expect(response.dig(:dialogAction, :message)).to eq(
        content: 'What is the first number?'
      )
    end

    it 'returns the response card' do
      expect(response.dig(:dialogAction, :responseCard)).to eq(response_card.to_lex)
    end
  end
end
