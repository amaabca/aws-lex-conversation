# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::CurrentIntent do
  describe '.slot_details!' do
    subject { described_class.slot_details!.call(value) }

    let(:value) do
      {
        'test' => {
          'resolutions' => [
            'value' => 'test'
          ],
          'originalValue' => 'TEST'
        }
      }
    end

    it 'returns a callable' do
      expect(described_class.slot_details!).to respond_to(:call)
    end

    it 'symbolizes hash keys' do
      expect(subject).to have_key(:test)
    end

    it 'creates nested SlotResolution instances' do
      expect(subject[:test].resolutions.first).to be_a(Aws::Lex::Conversation::Type::SlotResolution)
    end
  end
end
