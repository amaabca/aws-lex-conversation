# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::RecentIntentSummaryView do
  let(:event) { parse_fixture('events/intents/echo.json') }
  let(:lambda_context) { build(:context) }
  let(:conversation) { Aws::Lex::Conversation.new(event: event, context: lambda_context) }

  describe '#restore' do
    context 'with a Close action' do
      subject { build(:recent_intent_summary_view, :close) }

      it 'returns a close response' do
        response = subject.restore(
          conversation,
          message: {
            content: 'Test',
            contentType: 'PlainText'
          }
        )

        expect(response[:dialogAction]).to eq(
          message: {
            content: 'Test',
            contentType: 'PlainText'
          },
          type: 'Close'
        )
      end
    end

    context 'with a ConfirmIntent action' do
      subject { build(:recent_intent_summary_view, :confirm_intent) }

      it 'returns a confirm_intent response' do
        response = subject.restore(
          conversation,
          message: {
            content: 'Test',
            contentType: 'PlainText'
          }
        )

        expect(response[:dialogAction]).to eq(
          intentName: 'TestIntent',
          message: {
            content: 'Test',
            contentType: 'PlainText'
          },
          slots: {},
          type: 'ConfirmIntent'
        )
      end
    end

    context 'with a Delegate action' do
      subject { build(:recent_intent_summary_view, :delegate) }

      it 'returns a delegate response' do
        response = subject.restore(conversation)

        expect(response[:dialogAction]).to eq(
          slots: {},
          type: 'Delegate'
        )
      end
    end

    context 'with an ElicitIntent action' do
      subject { build(:recent_intent_summary_view, :elicit_intent) }

      it 'returns an elicit_intent response' do
        response = subject.restore(
          conversation,
          message: {
            content: 'Test',
            contentType: 'PlainText'
          }
        )

        expect(response[:dialogAction]).to eq(
          message: {
            content: 'Test',
            contentType: 'PlainText'
          },
          type: 'ElicitIntent'
        )
      end
    end

    context 'with an ElicitSlot action' do
      subject { build(:recent_intent_summary_view, :elicit_slot) }

      it 'returns an elicit_slot response' do
        response = subject.restore(
          conversation,
          message: {
            content: 'Test',
            contentType: 'PlainText'
          }
        )

        expect(response[:dialogAction]).to eq(
          intentName: 'TestIntent',
          message: {
            content: 'Test',
            contentType: 'PlainText'
          },
          slotToElicit: 'one',
          slots: { one: nil },
          type: 'ElicitSlot'
        )
      end
    end

    context 'with an invalid DialogActionType' do
      subject { build(:recent_intent_summary_view, :invalid) }

      it 'raises an ArgumentError' do
        expect { subject.restore(conversation) }.to raise_error(
          ArgumentError,
          'invalid DialogActionType: `Invalid`'
        )
      end
    end
  end
end
