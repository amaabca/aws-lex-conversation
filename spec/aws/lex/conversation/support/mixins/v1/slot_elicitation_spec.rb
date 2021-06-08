# frozen_string_literal: true

require_relative '../../../../../../fixtures/classes/v1/slot_elicitation_handler'

describe Aws::Lex::Conversation::Support::Mixins::V1::SlotElicitation do
  let(:event) { parse_fixture('events/intents/v1/echo.json') }
  let(:lambda_context) { build(:context) }
  let(:conversation) { Aws::Lex::V1::Conversation.new(event: event, context: lambda_context) }
  let(:number_of_elicitations) { 0 }

  subject { SlotElicitationHandler.new }

  before(:each) do
    conversation.session[:elicit_slot] = elicit_slot
    conversation.session[:SlotElicitations_one] = number_of_elicitations
    conversation.slots[:one].value = slot_value
    subject.conversation = conversation
  end

  describe '#slots_elicitable?' do
    let(:slot_value) { '' }

    context 'the slots are not flagged for elicitation' do
      let(:elicit_slot) { false }

      it 'returns false' do
        expect(subject.slots_elicitable?).to eq(false)
      end
    end

    context 'the slots are flagged for elicitation' do
      let(:elicit_slot) { true }

      it 'returns false' do
        expect(subject.slots_elicitable?).to eq(true)
      end
    end
  end

  describe '#elicit_slots!' do
    context 'the slot is not flagged for elicitation' do
      let(:slot_value) { '' }
      let(:elicit_slot) { false }

      it 'does not elicit the slot' do
        expect(subject.elicit_slots!).to eq(nil)
      end
    end

    context 'the slot is flagged for elicitation' do
      let(:elicit_slot) { true }

      context 'the slot value is blank' do
        let(:slot_value) { '' }

        it 'elicits the slot' do
          expect(subject.elicit_slots!).to include(
            dialogAction: {
              type: 'ElicitSlot',
              intentName: 'Lex_Intent_Echo',
              slots: {
                one: ''
              },
              slotToElicit: 'one',
              message: {
                contentType: 'PlainText',
                content: 'What is your favorite color?'
              }
            },
            sessionAttributes: {
              key: 'value',
              elicit_slot: true,
              SlotElicitations_one: 1
            }
          )
        end

        context 'but the maximum number of attempts has been reached' do
          let(:number_of_elicitations) { 3 }

          it 'calls the fallback lambda' do
            expect(subject.elicit_slots!).to include(
              dialogAction: {
                fulfillmentState: 'Failed',
                type: 'Close',
                message: {
                  contentType: 'PlainText',
                  content: 'Failed'
                }
              },
              sessionAttributes: {
                key: 'value',
                elicit_slot: true,
                SlotElicitations_one: 3
              }
            )
          end
        end
      end

      context 'the slot value is nil' do
        let(:slot_value) { nil }

        it 'elicits the slot' do
          expect(subject.elicit_slots!).to include(
            dialogAction: {
              type: 'ElicitSlot',
              intentName: 'Lex_Intent_Echo',
              slots: {
                one: nil
              },
              slotToElicit: 'one',
              message: {
                contentType: 'PlainText',
                content: 'What is your favorite color?'
              }
            },
            sessionAttributes: {
              key: 'value',
              elicit_slot: true,
              SlotElicitations_one: 1
            }
          )
        end

        context 'the slot value is present' do
          let(:slot_value) { 'Red' }

          it 'does not elicit the slot' do
            expect(subject.elicit_slots!).to eq(nil)
          end
        end
      end
    end
  end
end
