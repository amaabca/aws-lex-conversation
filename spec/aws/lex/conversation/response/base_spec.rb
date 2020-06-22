describe Aws::Lex::Conversation::Response::Base do
  describe '#dialog_action' do
    it 'raises NotImplementedError' do
      expect { subject.dialog_action }.to raise_error(NotImplementedError)
    end
  end
end
