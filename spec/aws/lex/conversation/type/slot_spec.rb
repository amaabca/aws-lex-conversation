# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::Slot do
  let(:current_intent) { build(:current_intent) }
  let(:name) { :test }
  subject { described_class.new(value: value, name: name, current_intent: current_intent) }

  describe '#filled?' do
    context 'it has a nil value' do
      let(:value) { nil }

      it 'returns false' do
        expect(subject.filled?).to eq(false)
      end
    end

    context 'it has a blank value' do
      let(:value) { '' }

      it 'returns false' do
        expect(subject.filled?).to eq(false)
      end
    end

    context 'it has a value' do
      let(:value) { '1' }

      it 'returns true' do
        expect(subject.filled?).to eq(true)
      end
    end
  end

  describe '#resolve!' do
    let(:name) { :resolvable }
    let(:value) { 'one two' }

    it 'overwrites the slot\'s value with the resolved value' do
      expect(subject.value).to eq(value)
      subject.resolve!
      expect(subject.value).to eq('12')
    end
  end

  describe '#resolved' do
    let(:name) { :resolvable }
    let(:value) { 'one two' }

    context 'with an index that exists' do
      it 'returns the resolved value' do
        expect(subject.resolved(index: 0)).to eq('12')
      end
    end

    context 'with an index that does not exist' do
      it 'returns the current value' do
        expect(subject.resolved(index: 1)).to eq(subject.value)
      end
    end
  end

  describe '#original_value' do
    let(:name) { :resolvable }
    let(:value) { 'one two' }

    it 'returns the original value as interpreted by Lex' do
      expect(subject.original_value).to eq('one. two.')
    end
  end

  describe '#resolvable?' do
    context 'when resolutions exist' do
      let(:name) { :resolvable }
      let(:value) { 'one two' }

      it 'returns true' do
        expect(subject.resolvable?).to be(true)
      end
    end

    context 'when resolutions do not exist' do
      let(:name) { :unresolvable }
      let(:value) { 'one two' }

      it 'returns false' do
        expect(subject.resolvable?).to be(false)
      end
    end
  end

  describe '#details' do
    context 'when a matching key in slot_details exists' do
      let(:name) { :resolvable }
      let(:value) { current_intent.slot_details[name].original_value }

      it 'returns a SlotDetail instance' do
        expect(subject.details).to be_a(Aws::Lex::Conversation::Type::SlotDetail)
      end

      it 'contains the correct resolution data' do
        expect(subject.details.resolutions.size).to eq(1)
      end
    end

    context 'when a matching key in slot_details does not exist' do
      let(:name) { :empty }
      let(:value) { nil }

      it 'returns a new null SlotDetail instance' do
        expect(subject.details).to be_a(Aws::Lex::Conversation::Type::SlotDetail)
      end

      it 'contains no resolution data' do
        expect(subject.details.resolutions).to be_empty
      end
    end
  end
end
