# frozen_string_literal: true

describe Aws::Lex::Conversation::Support::Mixins::Responses do
  let(:klass) { Struct.new(:lex).include(described_class) }
  let(:event) { parse_fixture('events/intents/basic.json') }
  let(:lex) { Aws::Lex::Conversation::Type::Event.shrink_wrap(event) }
  let(:response_card) { build(:response_card) }
  let(:message) { build(:message, :image_response_card) }

  subject { klass.new(lex) }

  describe '#close' do
    let(:response) do
      subject.close(
        fulfillment_state: 'Failed',
        messages: [message]
      )
    end

    it 'returns a close response' do
      expect(response).to have_action('Close')
    end

    it 'returns the message in the response' do
      expect(response).to have_message(
        content: message.content,
        contentType: message.content_type.raw,
        imageResponseCard: response_card.to_lex
      )
    end
  end

  describe '#confirm_intent' do
    let(:response) { subject.confirm_intent }

    it 'returns a ConfirmIntent response' do
      expect(response).to have_action('ConfirmIntent')
    end
  end

  describe '#delegate' do
    let(:response) { subject.delegate }

    it 'returns a Delegate response' do
      expect(response).to have_action('Delegate')
    end
  end

  describe '#elicit_intent' do
    let(:response) do
      subject.elicit_intent(
        messages: [message]
      )
    end

    it 'returns an ElicitIntent repsonse' do
      expect(response).to have_action('ElicitIntent')
    end

    it 'returns the message in the response' do
      expect(response).to have_message(
        content: message.content,
        contentType: message.content_type.raw,
        imageResponseCard: response_card.to_lex
      )
    end
  end

  describe '#elicit_slot' do
    let(:response) do
      subject.elicit_slot(
        slot_to_elicit: 'one',
        messages: [message]
      )
    end

    it 'returns an ElicitSlot response' do
      expect(response).to elicit_slot('one')
    end

    it 'returns the message in the response' do
      expect(response).to have_message(
        content: message.content,
        contentType: message.content_type.raw,
        imageResponseCard: response_card.to_lex
      )
    end
  end
end
