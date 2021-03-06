# frozen_string_literal: true

describe Aws::Lex::Conversation do
  let(:event) { parse_fixture('events/intents/echo.json') }
  let(:lambda_context) { build(:context) }

  subject { described_class.new(event: event, context: lambda_context) }

  describe '#respond' do
    let(:response) { subject.respond }

    context 'with a matching handler' do
      before(:each) do
        subject.handlers = [{
          handler: Aws::Lex::Conversation::Handler::Echo,
          options: {
            respond_on: ->(_conversation) { true }
          }
        }]
      end

      it 'returns a close response' do
        expect(response.dig(:dialogAction, :type)).to eq('Close')
      end
    end

    context 'without a matching handler' do
      before(:each) do
        subject.handlers = [{
          handler: Aws::Lex::Conversation::Handler::Echo,
          options: {
            respond_on: ->(_conversation) { false }
          }
        }]
      end

      it 'returns nil' do
        expect(response).to be_nil
      end
    end
  end

  describe 'handlers=(array)' do
    context 'when no options are present' do
      before(:each) do
        subject.handlers = [
          { handler: Aws::Lex::Conversation::Handler::Echo }
        ]
      end

      it 'sets options to an empty hash' do
        expect(subject.chain.first.options).to eq({})
      end
    end
  end

  describe '#handlers' do
    before(:each) do
      subject.handlers = [
        { handler: Aws::Lex::Conversation::Handler::Echo },
        { handler: Aws::Lex::Conversation::Handler::Delegate }
      ]
    end

    it 'returns an array' do
      expect(subject.handlers).to be_an(Array)
    end

    it 'contains the classes of each handler' do
      handlers = [
        Aws::Lex::Conversation::Handler::Echo,
        Aws::Lex::Conversation::Handler::Delegate
      ]
      expect(subject.handlers).to eq(handlers)
    end
  end

  describe '#intent_name' do
    it 'returns the name of the current intent' do
      expect(subject.intent_name).to eq('Lex_Intent_Echo')
    end
  end

  describe '#intent_confidence' do
    it 'returns an instance of Aws::Lex::Conversation::Type::IntentConfidence' do
      expect(subject.intent_confidence).to be_an(Aws::Lex::Conversation::Type::IntentConfidence)
    end
  end

  describe '#slots' do
    it 'returns the slot values of the input event' do
      expect(subject.slots[:one].value).to eq('1')
    end

    it 'contains Slot objects' do
      expect(subject.slots[:one]).to be_an(Aws::Lex::Conversation::Type::Slot)
    end
  end

  describe '#session' do
    it 'returns the session attributes of the input event' do
      expect(subject.session).to eq(key: 'value')
    end
  end
end
