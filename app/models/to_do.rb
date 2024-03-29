# frozen_string_literal: true

class ToDo < ApplicationRecord
  TEXT_MAX_LENGTH = 255
  belongs_to :user

  validates :text, presence: true,
                   length: { maximum: TEXT_MAX_LENGTH }
  validates :done, inclusion: { in: [true, false] }

  def to_s
    [id, user.name, text[0..19]].join ' ~ '
  end
end
