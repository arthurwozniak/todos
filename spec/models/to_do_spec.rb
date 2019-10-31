# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ToDo, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
  end
  context 'text validations' do
    it { should validate_presence_of(:text) }
    it { should validate_length_of(:text).is_at_most(ToDo::TEXT_MAX_LENGTH) }
  end
  context 'done validations' do
    before { build(:to_do) }
    it { should validate_inclusion_of(:done).in_array([false, true]) }
  end
end
