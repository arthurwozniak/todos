# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @full_content = {
      name: 'richard',
      email: 'feynman@example.com',
      access_token: SecureRandom.uuid
    }
  end

  test 'the validity - with full content is valid' do
    model = User.new @full_content
    assert model.valid?
    ensure_saved model
  end

  test 'the validity - without name is not valid' do
    model = User.new @full_content.except(:name)
    refute model.valid?
    assert model.errors[:name].include?(I18n.t('errors.messages.blank'))
  end

  test 'the validity - with duplicate name is not valid' do
    model = User.new @full_content.merge(name: users(:chomsky).name)
    refute model.valid?
    assert model.errors[:name].include?(I18n.t('errors.messages.taken'))
  end

  test 'the validity - with duplicate upcase name is not valid' do
    existing_user = users(:chomsky)
    refute_equal existing_user.name, existing_user.name.upcase
    model = User.new @full_content.merge(name: existing_user.name.upcase)
    refute model.valid?
    assert model.errors[:name].include?(I18n.t('errors.messages.taken'))
  end

  test 'the validity - without email is not valid' do
    model = User.new @full_content.except(:email)
    refute model.valid?
    assert model.errors[:email].include?(I18n.t('errors.messages.blank'))
    assert model.errors[:email].include?(I18n.t('errors.messages.invalid'))
  end

  test 'the validity - with duplicate email is not valid' do
    model = User.new @full_content.merge(email: users(:chomsky).email)
    refute model.valid?
    assert model.errors[:email].include?(I18n.t('errors.messages.taken'))
  end

  test 'the validity - with duplicate upcase email is not valid' do
    existing_user = users(:chomsky)
    refute_equal existing_user.email, existing_user.email.upcase
    model = User.new @full_content.merge(email: existing_user.email.upcase)
    refute model.valid?
    assert model.errors[:email].include?(I18n.t('errors.messages.taken'))
  end

  test 'the validity - without access_token is valid' do
    model = User.new @full_content.except(:access_token)
    model.valid?
    assert model.valid?
    ensure_saved model
  end

  test 'the validity - with duplicate access_token is not valid' do
    model = User.new @full_content.merge(access_token: users(:chomsky).access_token)
    refute model.valid?
    assert model.errors[:access_token].include?(I18n.t('errors.messages.taken'))
  end

  test 'the validity - multiple users can have nil access_token' do
    users(:chomsky).update! access_token: nil
    model = User.new @full_content.except(:access_token)
    assert model.valid?
    ensure_saved model
  end
end
