# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::Slot do
  let(:name) { :test }

  # overriden in test contexts
  let(:value) { build(:slot_value) }
  let(:active) { true }
  let(:shape) { build(:slot_shape) }

  subject do
    build(
      :slot,
      active: active,
      lex_value: value,
      name: name,
      shape: shape
    )
  end

  describe '#active?' do
    context 'when the slot is active for the current intent' do
      let(:active) { true }

      it 'returns true' do
        expect(subject.active?).to be(true)
      end
    end

    context 'when the slot is not active for the current intent' do
      let(:active) { false }

      it 'returns false' do
        expect(subject.active?).to be(false)
      end
    end
  end

  describe '#filled?' do
    context 'the slot is a Scalar' do
      before(:each) do

      end
    end
    context 'it has a nil value' do
      let(:value) { build(:slot_value, :nil) }

      it 'returns false' do
        expect(subject.filled?).to eq(false)
      end
    end

    context 'it has a blank value' do
      let(:value) { build(:slot_value, :blank) }

      it 'returns false' do
        expect(subject.filled?).to eq(false)
      end
    end

    context 'it has a value' do
      it 'returns true' do
        expect(subject.filled?).to eq(true)
      end
    end
  end

  describe '#blank?' do
    context 'it has a nil value' do
      let(:value) { build(:slot_value, :nil) }

      it 'returns true' do
        expect(subject.blank?).to eq(true)
      end
    end

    context 'it has a blank value' do
      let(:value) { build(:slot_value, :blank) }

      it 'returns false' do
        expect(subject.blank?).to eq(true)
      end
    end

    context 'it has a value' do
      it 'returns false' do
        expect(subject.blank?).to eq(false)
      end
    end
  end

  describe '#resolve!' do
    let(:name) { :resolvable }
    let(:value) { build(:slot_value, resolved_values: ['12']) }

    it 'overwrites the slot\'s value with the resolved value' do
      expect(subject.value).to eq(value.interpreted_value)
      subject.resolve!
      expect(subject.value).to eq(value.resolved_values.first)
    end
  end

  describe '#resolved' do
    let(:name) { :resolvable }
    let(:value) { build(:slot_value, resolved_values: ['12']) }

    context 'with an index that exists' do
      it 'returns the resolved value' do
        expect(value.resolved(index: 0)).to eq('12')
      end
    end

    context 'with an index that does not exist' do
      it 'returns the current value' do
        expect(value.resolved(index: 1)).to eq(subject.value)
      end
    end
  end

  describe '#resolvable?' do
    context 'when resolutions exist' do
      let(:name) { :resolvable }
      let(:value) { build(:slot_value, resolved_values: ['12']) }

      it 'returns true' do
        expect(subject.resolvable?).to be(true)
      end
    end

    context 'when resolutions do not exist' do
      let(:name) { :unresolvable }
      let(:value) { build(:slot_value, resolved_values: []) }

      it 'returns false' do
        expect(subject.resolvable?).to be(false)
      end
    end
  end

  # describe '#details' do
  #   context 'when a matching key in slot_details exists' do
  #     let(:name) { :resolvable }
  #     let(:value) { current_intent.slot_details[name].original_value }

  #     it 'returns a SlotDetail instance' do
  #       expect(subject.details).to be_a(Aws::Lex::Conversation::Type::SlotDetail)
  #     end

  #     it 'contains the correct resolution data' do
  #       expect(subject.details.resolutions.size).to eq(1)
  #     end
  #   end

  #   context 'when a matching key in slot_details does not exist' do
  #     let(:name) { :empty }
  #     let(:value) { nil }

  #     it 'returns a new null SlotDetail instance' do
  #       expect(subject.details).to be_a(Aws::Lex::Conversation::Type::SlotDetail)
  #     end

  #     it 'contains no resolution data' do
  #       expect(subject.details.resolutions).to be_empty
  #     end
  #   end
  # end

  describe '#requestable?' do
    context 'when the slot is active for the current intent' do
      let(:active) { true }

      context 'when the slot is filled' do
        it 'returns false' do
          expect(subject.requestable?).to be(false)
        end
      end

      context 'when the slot is not filled' do
        let(:value) { build(:slot_value, :nil) }

        it 'returns true' do
          expect(subject.requestable?).to be(true)
        end
      end
    end

    context 'when the slot is not active for the current intent' do
      let(:active) { false }

      context 'when the slot is filled' do
        it 'returns false' do
          expect(subject.requestable?).to be(false)
        end
      end

      context 'when the slot is not filled' do
        let(:value) { build(:slot_value, :nil) }

        it 'returns false' do
          expect(subject.requestable?).to be(false)
        end
      end
    end
  end

  describe '#value=' do
    before(:each) do
      subject.value = 'waffles'
    end

    it 'updates the value instance variable' do
      expect(subject.value).to eq('waffles')
    end

    # it 'updates the value in raw_slots' do
    #   expect(subject.current_intent.raw_slots[subject.name]).to eq('waffles')
    # end
  end
end
