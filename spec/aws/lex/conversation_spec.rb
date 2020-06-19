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
  end
end
