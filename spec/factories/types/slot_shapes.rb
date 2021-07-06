# frozen_string_literal: true

FactoryBot.define do
  factory(
    :slot_shape,
    class: Aws::Lex::Conversation::Type::SlotShape
  ) do
    shape { 'Scalar' }

    trait :list do
      shape { 'List' }
    end

    initialize_with do
      new(shape)
    end
  end
end
