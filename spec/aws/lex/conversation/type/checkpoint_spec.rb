# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::Checkpoint do
  let(:event) { parse_fixture('events/intents/echo.json') }
  let(:lambda_context) { build(:context) }
  let(:conversation) { Aws::Lex::Conversation.new(event: event, context: lambda_context) }

  describe '#restore' do
    context 'with a Close action' do
      subject { build(:checkpoint, :close) }

      it 'returns a close response' do
        response = subject.restore(
          conversation,
          messages: [
            {
              content: 'Test',
              contentType: 'PlainText'
            }
          ]
        )

        expect(response).to have_action('Close')
        expect(response).to have_message(
          content: 'Test',
          contentType: 'PlainText'
        )
      end
    end

    context 'with a ConfirmIntent action' do
      subject { build(:checkpoint, :confirm_intent) }

      it 'returns a confirm_intent response' do
        response = subject.restore(
          conversation,
          messages: [
            {
              content: 'Test',
              contentType: 'PlainText'
            }
          ]
        )

        expect(response).to have_action('ConfirmIntent')
        expect(response).to have_message(
          content: 'Test',
          contentType: 'PlainText'
        )
      end
    end

    context 'with a Delegate action' do
      subject { build(:checkpoint, :delegate) }

      it 'returns a delegate response' do
        response = subject.restore(conversation)

        expect(response).to have_action('Delegate')
      end
    end

    context 'with an ElicitIntent action' do
      subject { build(:checkpoint, :elicit_intent) }

      it 'returns an elicit_intent response' do
        response = subject.restore(
          conversation,
          messages: [
            {
              content: 'Test',
              contentType: 'PlainText'
            }
          ]
        )

        expect(response).to have_action('ElicitIntent')
        expect(response).to have_message(
          content: 'Test',
          contentType: 'PlainText'
        )
      end
    end

    context 'with an ElicitSlot action' do
      subject { build(:checkpoint, :elicit_slot) }

      it 'returns an elicit_slot response' do
        response = subject.restore(
          conversation,
          messages: [
            {
              content: 'Test',
              contentType: 'PlainText'
            }
          ]
        )

        expect(response).to elicit_slot('HasACat')
        expect(response).to have_message(
          {
            content: 'Test',
            contentType: 'PlainText'
          }
        )
      end
    end

    context 'with an invalid DialogActionType' do
      subject { build(:checkpoint, :invalid) }

      it 'raises an ArgumentError' do
        expect { subject.restore(conversation) }.to raise_error(
          ArgumentError,
          'invalid DialogActionType: `Invalid`'
        )
      end
    end
  end
end
