# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::Slot do
  subject { described_class.new(value: value) }

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
end
