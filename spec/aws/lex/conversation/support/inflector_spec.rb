# frozen_string_literal: true

describe Aws::Lex::Conversation::Support::Inflector do
  subject { described_class.new(input) }

  describe 'to_snake_case' do
    context 'with camelCase' do
      let(:input) { 'camelCaseValue' }

      it 'returns the snake_cased string' do
        expect(subject.to_snake_case).to eq('camel_case_value')
      end
    end

    context 'with a value that does not contain word characters' do
      let(:input) { 'application/json&test' }

      it 'filters out non-word characters' do
        expect(subject.to_snake_case).to eq('application_json_test')
      end
    end
  end

  describe 'to_camel_case' do
    let(:input) { 'my_cool_thing' }

    context 'with style == :lower' do
      it 'camel cases' do
        expect(subject.to_camel_case(:lower)).to eq('myCoolThing')
      end
    end

    context 'with style == :upper' do
      it 'camel cases' do
        expect(subject.to_camel_case(:upper)).to eq('MyCoolThing')
      end
    end

    context 'with an invalid style argument' do
      it 'raises ArgumentError' do
        expect { subject.to_camel_case(:test) }.to raise_error(ArgumentError)
      end
    end
  end
end
