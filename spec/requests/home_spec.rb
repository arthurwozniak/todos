# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home controller', type: :request do

  describe 'GET /' do
    it 'returns status code 200' do
      get '/'

      expect(response).to have_http_status 200
    end

    it 'returns info message' do
      get '/'

      expect(json_response['message']).to include I18n.t('home.welcome')
    end
  end
end
