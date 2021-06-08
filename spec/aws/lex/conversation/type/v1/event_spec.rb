# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::V1::Event do
  subject { described_class.shrink_wrap(event) }

  describe '#intents' do
    let(:event) { parse_fixture('events/intents/v1/nlu_ambiguous.json') }

    it 'returns an array with the first element equal to the current intent' do
      expect(subject.intents.first).to eq(subject.current_intent)
    end

    it 'returns an array containing the alternative intents' do
      expect(subject.intents[1..-1].map(&:name)).to eq(%w[
        Lex_Intent_2
        Lex_Intent_3
        AMAZON.FallbackIntent
        Lex_Intent_4
      ])
    end
  end

  describe '#session_attributes' do
    context 'when the value is null' do
      let(:event) { parse_fixture('events/intents/v1/null_session.json') }

      it 'returns an empty hash' do
        expect(subject.session_attributes).to be_a(Hash)
        expect(subject.session_attributes).to be_empty
      end
    end
  end

  describe '#request_attributes' do
    context 'when the value is null' do
      let(:event) { parse_fixture('events/intents/v1/null_session.json') }

      it 'returns an empty hash' do
        expect(subject.request_attributes).to be_a(Hash)
        expect(subject.request_attributes).to be_empty
      end
    end
  end
end
