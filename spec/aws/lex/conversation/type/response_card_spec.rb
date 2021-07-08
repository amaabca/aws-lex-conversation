# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::ResponseCard do
  let(:data) { parse_fixture('types/response_card.json') }
  subject { described_class.shrink_wrap(data['responseCard']) }

  describe '.shrink_wrap' do
    it 'coerces the buttons' do
      expect(subject.buttons).to be_an(Array)
      expect(subject.buttons.first).to be_a(Aws::Lex::Conversation::Type::ResponseCard::Button)
    end
  end
end
