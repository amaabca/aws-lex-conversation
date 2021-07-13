# frozen_string_literal: true

FactoryBot.define do
  factory(
    :slot_value,
    class: Aws::Lex::Conversation::Type::SlotValue
  ) do
    original_value { 'yes' }
    interpreted_value { 'Yes' }
    resolved_values { %w[Yes] }

    trait :nil do
      original_value { nil }
      interpreted_value { nil }
      resolved_values { [] }
    end

    trait :blank do
      original_value { '' }
      interpreted_value { '' }
      resolved_values { [''] }
    end

    initialize_with do
      new(
        original_value: original_value,
        interpreted_value: interpreted_value,
        resolved_values: resolved_values
      )
    end
  end
end
