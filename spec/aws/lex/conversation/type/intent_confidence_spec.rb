# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::IntentConfidence do
  let(:data) { parse_fixture('events/intents/nlu_ambiguous.json') }
  let(:event) { Aws::Lex::Conversation::Type::Event.shrink_wrap(data) }

  subject { described_class.new(event: event) }

  describe '#mean' do
    it 'returns the average of intent confidence scores' do
      expect(subject.mean).to eq(0.502)
    end
  end

  describe '#standard_deviation' do
    it 'returns the calculates standard deviation of intent confidence scores' do
      expect(subject.standard_deviation).to be_between(0.3, 0.4)
    end
  end

  describe '#ambigouous?' do
    it 'returns true' do
      expect(subject.ambiguous?).to be(true)
    end
  end

  describe '#unambiguous?' do
    it 'returns false' do
      expect(subject.unambiguous?).to be(false)
    end
  end

  describe '#candidates' do
    it 'returns an array consisting of all candidate intents' do
      expect(subject.candidates.map(&:name)).to eq(%w[
        Lex_Intent_1
        Lex_Intent_2
      ])
    end
  end

  describe '#similar_alternates' do
    it 'returns an array consisting of similar intents (not including the current)' do
      expect(subject.similar_alternates.map(&:name)).to eq(%w[
        Lex_Intent_2
      ])
    end
  end
end
