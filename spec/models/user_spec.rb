# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { should have_many(:to_dos).dependent(:destroy) }
  end
  context 'name validations' do
    subject { build(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
  context 'email validations' do
    subject { build(:user) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should_not allow_value('invalid mail@example.com').for(:email) }
    it { should_not allow_value('invalid_mail@example.c').for(:email) }
    it { should_not allow_value('invalid@mail@example.com').for(:email) }
    it { should allow_value('valid_mail@example.com').for(:email) }
  end
  context 'access_token validations' do
    subject { build(:user) }
    it { should validate_uniqueness_of(:access_token).case_insensitive.allow_nil }
  end
end
