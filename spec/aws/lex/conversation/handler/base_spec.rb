# frozen_string_literal: true

describe Aws::Lex::Conversation::Handler::V1::Base do
  let(:successor) { Aws::Lex::Conversation::Handler::V1::Echo.new(successor: nil, options: {}) }
  subject { described_class.new(successor: successor, options: {}) }

  describe '#response' do
    it 'raises NotImplementedError' do
      expect { subject.response(nil) }.to raise_error(NotImplementedError)
    end
  end

  describe '#handle' do
    context 'when a successor is defined' do
      context 'when the current handler does not respond' do
        it 'calls the successor\'s #handle method' do
          expect(successor).to receive(:handle).once.and_call_original
          subject.handle(nil)
        end
      end
    end
  end
end
