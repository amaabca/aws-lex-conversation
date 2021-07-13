# frozen_string_literal: true

describe Aws::Lex::Conversation::Response::Base do
  subject { described_class.new(session_state: build(:session_state)) }

  describe '#dialog_action' do
    it 'raises NotImplementedError' do
      expect { subject.dialog_action }.to raise_error(NotImplementedError)
    end
  end
end
