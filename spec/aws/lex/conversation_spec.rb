# frozen_string_literal: true

describe Aws::Lex::Conversation do
  let(:event) { parse_fixture('events/intents/echo.json') }
  let(:lambda_context) { build(:context) }

  subject { described_class.new(event: event, context: lambda_context) }

  describe '#respond' do
    context 'with a matching handler' do
      before(:each) do
        subject.handlers = [{ handler: Aws::Lex::Conversation::Handler::Echo }]
      end

      it 'returns a close response' do
        expect(subject.respond).to eq(
          dialogAction: {
            type: 'Close',
            fulfillmentState: 'Fulfilled',
            message: {
              contentType: 'PlainText',
              content: 'Echo Test'
            }
          }
        )
      end
    end
  end
end
