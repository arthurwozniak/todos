# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :ensure_token_exists, :authenticate

  # GET /
  def index
    render json: { message: I18n.t('home.welcome') }, status: 200
  end
end
