# frozen_string_literal: true

class User < ApplicationRecord
  has_many :to_dos, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :access_token, uniqueness: true, unless: ->(model) { model.access_token.nil? }

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
