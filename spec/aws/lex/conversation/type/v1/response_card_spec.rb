# frozen_string_literal: true

describe Aws::Lex::Conversation::Type::V1::ResponseCard do
  let(:data) { parse_fixture('types/v1/response_card.json') }
  subject { described_class.shrink_wrap(data['responseCard']) }

  describe '.shrink_wrap' do
    it 'coerces the version' do
      expect(subject.version).to be_an(Integer)
    end

    it 'coerces the content_type' do
      expect(subject.content_type).to be_a(Aws::Lex::Conversation::Type::V1::ResponseCard::ContentType)
      expect(subject.content_type.raw).to eq('application/vnd.amazonaws.card.generic')
    end

    it 'coerces the generic_attachments' do
      expect(subject.generic_attachments).to be_an(Array)
      expect(subject.generic_attachments.first).to be_a(Aws::Lex::Conversation::Type::V1::ResponseCard::GenericAttachment)
    end
  end
end
