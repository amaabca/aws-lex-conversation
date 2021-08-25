# frozen_string_literal: true

describe Aws::Lex::Conversation::Slot::Elicitation do
  let(:event) { parse_fixture('events/intents/elicit.json') }
  let(:lambda_context) { build(:context) }
  let(:conversation) { Aws::Lex::Conversation.new(event: event, context: lambda_context) }

  subject do
    described_class.new(
      name: 'HasACat',
      maximum_elicitations: 1,
      message: message,
      content_type: 'PlainText',
      follow_up_message: 'Do you have a feline?',
      fallback: fallback
    )
  end

  before(:each) do
    subject.conversation = conversation
  end

  describe '#elicit!' do
    let(:message) { 'Do you have a cat?' }
    let(:fallback) do
      ->(c) do
        c.close(
          fulfillment_state: 'Failed',
          messages: [
            {
              content: 'I give up.',
              contentType: 'PlainText'
            }
          ]
        )
      end
    end

    context 'with the first iteration' do
      it 'returns the first elicitation message' do
        expect(subject.elicit![:messages][0][:content]).to eq('Do you have a cat?')
      end

      context 'when the message is an instance of Aws::Lex::Conversation::Type::Message' do
        let(:message) do
          ->(_) do
            Aws::Lex::Conversation::Type::Message.new(
              content: '<speak>Do you have a cat?</speak>',
              contentType: 'SSML'
            )
          end
        end

        it 'returns the first elicitation message' do
          expect(subject.elicit![:messages][0][:content]).to eq('<speak>Do you have a cat?</speak>')
        end
      end
    end

    context 'with the second iteration' do
      before(:each) do
        subject.elicit!
      end

      it 'returns the follow_up_message' do
        expect(subject.elicit![:messages][0][:content]).to eq('Do you have a feline?')
      end
    end

    context 'when maximum_elicitations are exceeded' do
      before(:each) do
        2.times { subject.elicit! }
      end

      it 'returns the fallback content' do
        response = subject.elicit!

        expect(response[:messages][0][:content]).to eq('I give up.')
        expect(response[:sessionState][:dialogAction][:type]).to eq('Close')
      end

      context 'when the fallback callback returns an Aws::Lex::Conversation::Type::Message' do
        let(:fallback) do
          ->(c) do
            c.close(
              fulfillment_state: 'Failed',
              messages: [
                Aws::Lex::Conversation::Type::Message.new(
                  content: '<speak>Fallback</speak>',
                  content_type: Aws::Lex::Conversation::Type::Message::ContentType.new('SSML')
                )
              ]
            )
          end
        end

        it 'returns the fallback content' do
          response = subject.elicit!

          expect(response[:messages][0][:content]).to eq('<speak>Fallback</speak>')
          expect(response[:messages][0][:contentType]).to eq('SSML')
          expect(response[:sessionState][:dialogAction][:type]).to eq('Close')
        end
      end
    end
  end
end
