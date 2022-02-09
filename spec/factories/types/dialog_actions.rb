# frozen_string_literal: true

FactoryBot.define do
  factory(
    :dialog_action,
    class: Aws::Lex::Conversation::Type::DialogAction
  ) do
    type { Aws::Lex::Conversation::Type::DialogActionType.new('Close') }

    initialize_with do
      new(type: type)
    end
  end
end
