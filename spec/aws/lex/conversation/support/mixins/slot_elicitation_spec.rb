# frozen_string_literal: true

require_relative '../../../../../fixtures/classes/slot_elicitation_handler'

describe Aws::Lex::Conversation::Support::Mixins::SlotElicitation do
  let(:event) { parse_fixture('events/intents/echo.json') }
  let(:lambda_context) { build(:context) }
  let(:conversation) { Aws::Lex::Conversation.new(event: event, context: lambda_context) }
  let(:number_of_elicitations) { 0 }

  subject { SlotElicitationHandler.new }

  before(:each) do
    conversation.session[:elicit_slot] = elicit_slot
    conversation.session[:SlotElicitations_HasACat] = number_of_elicitations
    conversation.slots[:HasACat].value = slot_value
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
            messages: [
              {
                content: 'Do you have a cat?',
                contentType: 'PlainText'
              }
            ],
            sessionState: {
              activeContexts: [],
              dialogAction: {
                slotToElicit: 'HasACat',
                type: 'ElicitSlot'
              },
              intent: {
                confirmationState: 'None',
                kendraResponse: nil,
                name: 'Lex_Intent_Echo',
                nluConfidence: 1.0,
                originatingRequestId: nil,
                slots: {
                  HasACat: {
                    shape: 'Scalar',
                    value: {
                      interpretedValue: 'Yes',
                      originalValue: 'yes',
                      resolvedValues: ['Yes']
                    },
                    values: []
                  }
                },
                state: 'ReadyForFulfillment'
              },
              sessionAttributes: {
                SlotElicitations_HasACat: 1,
                bar: '231234215125',
                baz: 'Apples',
                checkpoints: 'W10',
                elicit_slot: true,
                foo: 'NO'
              }
            }
          )
        end

        context 'but the maximum number of attempts has been reached' do
          let(:number_of_elicitations) { 3 }

          it 'calls the fallback lambda' do
            expect(subject.elicit_slots!).to include(
              messages: [
                {
                  content: 'Failed',
                  contentType: 'PlainText'
                }
              ],
              sessionState: {
                activeContexts: [],
                dialogAction: {
                  slotToElicit: nil,
                  type: 'Close'
                },
                intent: {
                  confirmationState: 'None',
                  kendraResponse: nil,
                  name: 'Lex_Intent_Echo',
                  nluConfidence: 1.0,
                  originatingRequestId: nil,
                  slots: {
                    HasACat: {
                      shape: 'Scalar',
                      value: {
                        interpretedValue: '',
                        originalValue: 'yes',
                        resolvedValues: ['Yes']
                      },
                      values: []
                    }
                  },
                  state: 'Failed'
                },
                sessionAttributes: {
                  SlotElicitations_HasACat: 3,
                  bar: '231234215125',
                  baz: 'Apples',
                  checkpoints: 'W10',
                  elicit_slot: true,
                  foo: 'NO'
                }
              }
            )
          end
        end
      end

      context 'the slot value is nil' do
        let(:slot_value) { nil }

        it 'elicits the slot' do
          expect(subject.elicit_slots!).to include(
            messages: [
              {
                content: 'Do you have a cat?',
                contentType: 'PlainText'
              }
            ],
            sessionState: {
              activeContexts: [],
              dialogAction: {
                slotToElicit: 'HasACat',
                type: 'ElicitSlot'
              },
              intent: {
                confirmationState: 'None',
                kendraResponse: nil,
                name: 'Lex_Intent_Echo',
                nluConfidence: 1.0,
                originatingRequestId: nil,
                slots: {
                  HasACat: {
                    shape: 'Scalar',
                    value: {
                      interpretedValue: 'Yes',
                      originalValue: 'yes',
                      resolvedValues: ['Yes']
                    },
                    values: []
                  }
                },
                state: 'ReadyForFulfillment'
              },
              sessionAttributes: {
                SlotElicitations_HasACat: 1,
                bar: '231234215125',
                baz: 'Apples',
                checkpoints: 'W10',
                elicit_slot: true,
                foo: 'NO'
              }
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
