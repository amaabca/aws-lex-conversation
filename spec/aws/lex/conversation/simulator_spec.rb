describe Aws::Lex::Conversation::Simulator do
  describe '#event' do
    let(:event) { subject.event }

    before(:each) do
      subject
        .transcript('My Waffles')
        .intent(name: 'My_Intent')
        .interpretation(
          name: 'Something_Else',
          nlu_confidence: 0.40,
          sentiment_response: {
            sentiment: 'POSITIVE',
            sentiment_score: {
              mixed: 0.01,
              negative: 0.001,
              neutral: 0.95,
              positive: 0.05
            }
          }
        )
        .slot(name: 'MySlot', value: 'TEST')
        .context(name: 'waffle_is_hot')
        .invocation_source('DialogCodeHook')
    end

    it 'sets the transcript' do
      expect(event).to have_transcript('My Waffles')
    end

    it 'routes to the specified intent' do
      expect(event).to route_to_intent('My_Intent')
    end

    it 'sets the context' do
      expect(event).to have_active_context('waffle_is_hot')
    end

    it 'sets the invocation source' do
      expect(event).to have_invocation_source('DialogCodeHook')
    end

    it 'adds an interpretation' do
      expect(event).to have_interpretation('Something_Else')
    end
  end
end
