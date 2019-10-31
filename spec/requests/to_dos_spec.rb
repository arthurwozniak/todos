# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "ToDo's API", type: :request do
  # initialize test data
  let(:user_1) { build(:user) }
  let(:user_2) { build(:user) }
  let!(:todos_user_1) { create_list(:to_do, 10, user: user_1) }
  let!(:todos_user_2) { create_list(:to_do, 10, user: user_2) }

  describe 'GET /to_dos' do
    context 'with unauthenticated user' do
      it 'returns status code 401' do
        get '/to_dos'

        expect(response).to have_http_status 401
      end

      it 'returns error with missing token message' do
        get '/to_dos'

        expect(json_response['errors']).to include I18n.t('errors.authentication.missing_token')
      end

      it 'returns error with invalid token message' do
        get '/to_dos', params: {}, headers: { 'HTTP_AUTHORIZATION' => 'Bearer foobar' }

        expect(json_response['errors']).to include I18n.t('errors.authentication.invalid_token')
      end
    end

    context 'with authenticated user' do
      before { get '/to_dos', params: {}, headers: headers_of(user_1) }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'returns array of ToDo records' do
        expect(json_response.class).to equal Array
        expect(json_response.first.class).to equal Hash
        expect(json_response.first.keys).to match_array ToDo.column_names
      end

      it 'returns only users ToDo records' do
        expect(json_response.map { |to_do| to_do['user_id'] }.uniq).to match_array [user_1.id]
      end
    end
  end

  describe 'GET /to_dos/:id' do
    context 'with authorized user' do
      before { get "/to_dos/#{todos_user_1.first.id}", params: {}, headers: headers_of(user_1) }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'returns correct ToDo record' do
        expect(json_response['id']).to equal todos_user_1.first.id
        expect(json_response['text']).to match todos_user_1.first.text
        expect(json_response['user_id']).to match user_1.id
        expect(json_response['created_at']).to match todos_user_1.first.created_at.iso8601(3)
        expect(json_response['updated_at']).to match todos_user_1.first.updated_at.iso8601(3)
      end
    end

    context 'with unauthorized user' do
      before { get "/to_dos/#{todos_user_2.first.id}", params: {}, headers: headers_of(user_1) }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns record not found error' do
        expect(json_response['errors']).to include "Couldn't find ToDo"
      end
    end
  end

  describe 'POST /to_dos/' do
    let(:todo_values) { { user_id: user_1.id, text: Faker::Lorem.characters(number: 10), done: false } }

    context 'with valid values' do
      before { post '/to_dos/', params: { to_do: todo_values }, headers: headers_of(user_1) }

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end

      it 'return freshly created ToDo' do
        expect(json_response['text']).to match todo_values[:text]
        expect(json_response['user_id']).to match user_1.id
        expect(json_response['done']).to match todo_values[:done]
      end
    end

    context 'with invalid values' do
      before { post '/to_dos/', params: { to_do: todo_values.except(:text) }, headers: headers_of(user_1) }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'return error details' do
        expect(json_response['errors']).to include "Text can't be blank"
      end
    end
  end

  describe 'PUT /to_dos/:id' do
    let(:to_do) { todos_user_1.first }

    context 'update with unauthorized user' do
      before { put "/to_dos/#{to_do.id}", params: { to_do: { done: !to_do.done } }, headers: headers_of(user_2) }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns record not found error' do
        expect(json_response['errors']).to include "Couldn't find ToDo"
      end
    end

    context 'update with authorized user' do
      before { put "/to_dos/#{to_do.id}", params: { to_do: { done: !to_do.done } }, headers: headers_of(user_1) }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'return updated values' do
        expect(json_response['id']).to match to_do.id
        expect(json_response['done']).to equal !to_do.done
      end
    end
  end

  describe 'DELETE /to_dos/:id' do
    let(:to_do) { todos_user_1.first }

    context 'update with unauthorized user' do
      before { delete "/to_dos/#{to_do.id}", params: { to_do: { done: !to_do.done } }, headers: headers_of(user_2) }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns record not found error' do
        expect(json_response['errors']).to include "Couldn't find ToDo"
      end
    end

    context 'update with authorized user' do
      before { delete "/to_dos/#{to_do.id}", params: { to_do: { done: !to_do.done } }, headers: headers_of(user_1) }

      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end
    end
  end
end
