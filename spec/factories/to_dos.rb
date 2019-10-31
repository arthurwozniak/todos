# frozen_string_literal: true

FactoryBot.define do
  factory :to_do do
    text { Faker::Lorem.paragraph_by_chars(number: ToDo::TEXT_MAX_LENGTH, supplemental: false) }
    done { [true, false].sample }
    user
  end
end
