# frozen_string_literal: true

FactoryBot.define do
  factory(
    :slot,
    class: Aws::Lex::Conversation::Type::Slot
  ) do
    name { 'TestSlot' }
    shape { build(:slot_shape, :scalar) }
    lex_value { build(:slot_value) }
    lex_values { [] }

    trait :list do
      shape { 'List' }
      lex_value { nil }
      lex_values { build_list(:slot_value, 1) }
    end

    initialize_with do
      new(
        name: name,
        shape: shape,
        lex_value: lex_value,
        lex_values: lex_values
      )
    end
  end
end
