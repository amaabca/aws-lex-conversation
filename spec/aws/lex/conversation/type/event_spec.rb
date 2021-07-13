# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::Event do
  subject { described_class.shrink_wrap(event) }

  describe '#intents' do
    let(:event) { parse_fixture('events/intents/nlu_ambiguous.json') }

    it 'returns an array with the first element equal to the current intent' do
      expect(subject.intents.first.name).to eq(subject.current_intent.name)
    end

    it 'returns an array containing the alternative intents' do
      expect(subject.intents[1..-1].map(&:name)).to eq(%w[
        Lex_V2_FallbackIntent
        Lex_V2_Intent_B
        Lex_V2_Intent_C
        Lex_V2_Intent_D
      ])
    end
  end

  describe '#alternate_intents' do
    let(:event) { parse_fixture('events/intents/nlu_ambiguous.json') }

    it 'returns an array containing the alternative intents' do
      expect(subject.alternate_intents.map(&:name)).to eq(%w[
        Lex_V2_FallbackIntent
        Lex_V2_Intent_B
        Lex_V2_Intent_C
        Lex_V2_Intent_D
      ])
    end
  end

  describe '#session_attributes' do
    context 'when the value is null' do
      let(:event) { parse_fixture('events/intents/null_session.json') }

      it 'returns an empty hash' do
        expect(subject.session_state.session_attributes).to be_a(Hash)
        expect(subject.session_state.session_attributes).to be_empty
      end
    end
  end

  describe '#request_attributes' do
    context 'when the value is null' do
      let(:event) { parse_fixture('events/intents/null_session.json') }

      it 'returns an empty hash' do
        expect(subject.request_attributes).to be_a(Hash)
        expect(subject.request_attributes).to be_empty
      end
    end
  end
end
