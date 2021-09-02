# frozen_string_literal: true

describe Aws::Lex::Conversation do
  let(:event) { parse_fixture('events/intents/echo.json') }
  let(:lambda_context) { build(:context) }

  subject { described_class.new(event: event, context: lambda_context) }

  describe '#checkpoint!' do
    context 'when an existing checkpoint does not exist' do
      before(:each) do
        # set checkpoints to an empty array
        subject.simulate!.session(checkpoints: 'W10')
      end

      it 'creates an element in session_attributes.checkpoints' do
        subject.checkpoint!(
          label: 'savePoint',
          dialog_action_type: 'ElicitSlot',
          fulfillment_state: ''
        )

        expect(subject.checkpoints.size).to eq(1)
      end
    end

    context 'when an existing checkpoint does exist' do
      let(:view) { subject.checkpoint(label: 'savePoint') }

      before(:each) do
        subject.checkpoint!(
          label: 'savePoint',
          dialog_action_type: 'ElicitSlot',
          fulfillment_state: ''
        )
      end

      it 'updates the existing checkpoint in recentIntentSummaryView' do
        subject.checkpoint!(
          label: 'savePoint',
          dialog_action_type: 'ConfirmIntent',
          fulfillment_state: ''
        )

        expect(view.dialog_action_type).to eq('ConfirmIntent')
      end
    end
  end

  describe '#checkpoint?' do
    context 'when the event already contains the savePoint checkpoint' do
      let(:event) { parse_fixture('events/intents/with_checkpoint.json') }

      it 'returns true' do
        expect(subject.checkpoint?(label: 'savePoint')).to be(true)
      end
    end

    context 'when a checkpoint exists' do
      before(:each) do
        subject.checkpoint!(
          label: 'savePoint',
          dialog_action_type: 'ElicitSlot'
        )
      end

      it 'returns true' do
        expect(subject.checkpoint?(label: 'savePoint')).to be(true)
      end
    end

    context 'when a checkpoint does not exist' do
      it 'returns false' do
        expect(subject.checkpoint?(label: 'waffles')).to be(false)
      end
    end
  end

  describe '#checkpoint' do
    context 'when a checkpoint exists' do
      before(:each) do
        subject.checkpoint!(
          label: 'savePoint',
          dialog_action_type: 'ElicitSlot'
        )
      end

      it 'returns the checkpoint' do
        expect(subject.checkpoint(label: 'savePoint')).to be_an(
          Aws::Lex::Conversation::Type::Checkpoint
        )
      end
    end

    context 'when a checkpoint does not exist' do
      it 'returns nil' do
        expect(subject.checkpoint(label: 'waffles')).to be_nil
      end
    end
  end

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
        expect(response).to have_action('Close')
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
      expect(subject.slots[:HasACat].value).to eq('Yes')
    end

    it 'contains Slot objects' do
      expect(subject.slots[:HasACat]).to be_an(Aws::Lex::Conversation::Type::Slot)
    end

    context 'with a slot name that does not exist' do
      let(:slot) { subject.slots[:waffles] }

      it 'returns an instance of Slot' do
        expect(slot).to be_an(Aws::Lex::Conversation::Type::Slot)
      end

      it 'has a blank value' do
        expect(slot).to be_blank
      end
    end
  end

  describe '#session' do
    it 'returns the session attributes of the input event' do
      expect(subject).to include_session_values(
        bar: '231234215125',
        baz: 'Apples',
        foo: 'NO'
      )
    end
  end

  describe '#stash' do
    it 'returns a Hash value' do
      expect(subject.stash).to be_a(Hash)
    end

    it 'may contain interaction-scoped ephemeral data' do
      thing = Struct.new(:thing).new('thing')
      subject.stash[:my_thing] = thing

      expect(subject.stash[:my_thing]).to eq(thing)
    end
  end
end
