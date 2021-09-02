# frozen_string_literal: true

describe Aws::Lex::Conversation::Handler::SlotResolution do
  let(:lambda_context) { build(:context) }
  let(:event) { parse_fixture('events/intents/basic.json') }
  let(:conversation) { Aws::Lex::Conversation.new(event: event, context: lambda_context) }

  describe '#will_respond?' do
    it 'returns true by default' do
      expect(subject.will_respond?(conversation)).to be(true)
    end
  end

  describe '#response' do
    let(:response) { subject.response(conversation) }

    context 'without a successor in the handler chain' do
      it 'raises Aws::Lex::Conversation::Exception::MissingHandler' do
        expect { response }.to raise_error(Aws::Lex::Conversation::Exception::MissingHandler)
      end
    end

    context 'with a successor in the handler chain' do
      before(:each) do
        subject.successor = Aws::Lex::Conversation::Handler::Delegate.new(
          options: {
            respond_on: ->(_c) { true }
          }
        )
      end

      it 'returns the response from the successor' do
        expect(response).to have_action('Delegate')
      end
    end
  end
end
