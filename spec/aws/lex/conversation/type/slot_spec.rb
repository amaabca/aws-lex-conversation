# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::Slot do
  let(:name) { :test }

  # overriden in test contexts
  let(:value) { build(:slot_value) }
  let(:active) { true }
  let(:shape) { build(:slot_shape) }
  let(:values) { [] }

  subject do
    build(
      :slot,
      active: active,
      lex_value: value,
      lex_values: values,
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
    context 'list slot' do
      let(:shape) { build(:slot_shape, :list) }

      context 'it has no values' do
        it 'returns false' do
          expect(subject.filled?).to eq(false)
        end
      end

      context 'it has a value' do
        let(:values) { build_list(:slot_value, 1) }

        it 'returns true' do
          expect(subject.filled?).to eq(true)
        end
      end
    end

    context 'scalar slot' do
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

  describe '#to_lex' do
    context 'with a scalar slot shape' do
      it 'returns the value' do
        expect(subject.to_lex[:value]).to be_a(Hash)
      end
    end

    context 'with a list slot shape' do
      let(:shape) { build(:slot_shape, :list) }
      let(:values) { build_list(:slot_value, 2) }

      it 'returns the values' do
        expect(subject.to_lex[:values].size).to eq(2)
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

  describe '#value' do
    context 'list slot' do
      let(:shape) { build(:slot_shape, :list) }

      it 'raises a TypeError' do
        expect { subject.value }.to raise_error(TypeError)
      end
    end
  end

  describe '#values' do
    context 'scalar slot' do
      let(:shape) { build(:slot_shape, :scalar) }

      it 'raises a TypeError' do
        expect { subject.values }.to raise_error(TypeError)
      end
    end
  end

  describe '#value=' do
    context 'scalar slot' do
      before(:each) do
        subject.value = 'waffles'
      end

      it 'updates the value instance variable' do
        expect(subject.value).to eq('waffles')
      end
    end

    context 'list slot' do
      let(:shape) { build(:slot_shape, :list) }

      it 'raises a TypeError' do
        expect { subject.value = 'waffles' }.to raise_error(TypeError)
      end
    end
  end

  describe '#values=' do
    let(:values) { build_list(:slot_value, 2) }
    let(:new_values) { %w[cheese pepperoni] }

    context 'list slot' do
      let(:shape) { build(:slot_shape, :list) }

      before(:each) do
        subject.values = new_values
      end

      it 'sets slot values' do
        expect(subject.values).to eq(new_values)
      end

      it 'sets scalar slot values' do
        expect(subject.lex_values.map(&:shape).all?(&:scalar?)).to eq(true)
      end
    end

    context 'scalar slot' do
      let(:shape) { build(:slot_shape, :scalar) }

      it 'raises a TypeError' do
        expect { subject.values = new_values }.to raise_error(TypeError)
      end
    end
  end
end
