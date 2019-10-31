# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Kpop.solo }
    email { Faker::Internet.email }
    access_token { SecureRandom.uuid }
  end
end
