# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :ensure_token_exists, :authenticate

    attr_reader :current_user
  end

  private

  def ensure_token_exists
    return if request.headers['HTTP_AUTHORIZATION'].present?

    render json: { errors: [I18n.t('errors.authentication.missing_token')] }, status: :unauthorized
  end

  def authenticate
    @current_user = User.find_by! access_token: http_auth_header_token
  rescue ActiveRecord::RecordNotFound
    render json: { errors: [I18n.t('errors.authentication.invalid_token')] }, status: :unauthorized
  end

  def http_auth_header_token
    request.headers['HTTP_AUTHORIZATION'].split(' ').last
  end
end
