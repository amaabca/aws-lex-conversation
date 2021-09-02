# frozen_string_literal: true

describe Aws::Lex::Conversation::Slot::Elicitation do
  let(:event) { parse_fixture('events/intents/elicit.json') }
  let(:lambda_context) { build(:context) }
  let(:conversation) { Aws::Lex::Conversation.new(event: event, context: lambda_context) }

  let(:follow_up_messages) do
    [
      Aws::Lex::Conversation::Type::Message.new(
        content: 'Do you have a feline?',
        content_type: 'PlainText'
      )
    ]
  end

  subject do
    described_class.new(
      name: 'HasACat',
      maximum_elicitations: 1,
      messages: messages,
      follow_up_messages: follow_up_messages,
      fallback: fallback
    )
  end

  before(:each) do
    subject.conversation = conversation
  end

  describe '#elicit!' do
    let(:messages) do
      [
        Aws::Lex::Conversation::Type::Message.new(
          content: 'Do you have a cat?',
          content_type: 'PlainText'
        )
      ]
    end
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
        expect(subject.elicit!).to have_message(content: 'Do you have a cat?')
      end

      context 'when the message is an instance of Aws::Lex::Conversation::Type::Message' do
        let(:messages) do
          ->(_) do
            [
              Aws::Lex::Conversation::Type::Message.new(
                content: 'Do you have a cat?',
                content_type: 'PlainText'
              )
            ]
          end
        end

        it 'returns the first elicitation message' do
          expect(subject.elicit!).to have_message(content: 'Do you have a cat?')
        end
      end
    end

    context 'with the second iteration' do
      before(:each) do
        subject.elicit!
      end

      it 'returns the follow_up_message' do
        expect(subject.elicit!).to have_message(content: 'Do you have a feline?')
      end
    end

    context 'when maximum_elicitations are exceeded' do
      before(:each) do
        2.times { subject.elicit! }
      end

      it 'returns the fallback content' do
        response = subject.elicit!

        expect(response).to have_message(content: 'I give up.')
        expect(response).to have_action('Close')
      end

      context 'when the fallback callback returns an Aws::Lex::Conversation::Type::Message' do
        context 'when there is a fallback' do
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

            expect(response).to have_message(
              content: '<speak>Fallback</speak>',
              contentType: 'SSML'
            )
            expect(response).to have_action('Close')
          end
        end

        context 'when there is not a fallback' do
          let(:fallback) { nil }

          it 'will not elicit' do
            expect(subject.elicit!).to eq(false)
          end
        end
      end
    end
  end
end
