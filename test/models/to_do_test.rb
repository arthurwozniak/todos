require 'test_helper'

class ToDoTest < ActiveSupport::TestCase
  setup do
    @full_content = {
      text: 'As a research tool, the internet is invaluable.',
      done: true,
      user: users(:chomsky)
    }
  end

  test 'the validity - with full content is valid' do
    model = ToDo.new @full_content
    assert model.valid?
    ensure_saved model
  end

  test 'the validity - without text is not valid' do
    model = ToDo.new @full_content.except(:text)
    refute model.valid?
    assert model.errors[:text].include?(I18n.t('errors.messages.blank'))
  end

  test 'the validity - with too long text is not valid' do
    model = ToDo.new @full_content.merge(text: 'a' * (ToDo::TEXT_MAX_LENGTH + 1))
    refute model.valid?
    assert model.errors[:text].include?(I18n.t('errors.messages.too_long.other', count: ToDo::TEXT_MAX_LENGTH))
  end

  test 'the validity - without done is not valid' do
    model = ToDo.new @full_content.except(:done)
    refute model.valid?
    assert model.errors[:done].include?(I18n.t('errors.messages.blank'))
  end

  test 'the validity - without user is not valid' do
    model = ToDo.new @full_content.except(:user)
    refute model.valid?
    assert model.errors[:user].include?(I18n.t('errors.messages.required'))
  end
end
