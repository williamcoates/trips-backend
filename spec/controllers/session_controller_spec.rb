require 'rails_helper'

describe SessionsController do

  let(:user) { create(:user) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'logging in' do

    it 'with valid credentials' do
      post :create, format: :json, user: { email: user.email, password: user.password }
      expect(response).to be_success
      expect(json_response[:email]).to eql(user.email)
    end

    it 'with invalid credentials' do
      post :create, format: :json, user: { email: 'foo', password: 'foo'}
      expect(response).to have_http_status(:unauthorized)
      expect(json_response[:error]).to match(/invalid email or password/i)
    end

    it 'strips spaces from email' do
      post :create, format: :json, user: { email: "  #{user.email} ", password: user.password }
      expect(response).to be_success
    end

  end

  context 'logging out' do

    it 'if logged in' do
      sign_in user
      delete :destroy, format: :json
      expect(response).to have_http_status(:no_content)
    end

    # Unfortunately Devise does not distiguish a logout on a valid session
    # to a logout on an invalid session...
    it 'if not logged in' do
      delete :destroy, format: :json
      expect(response).to have_http_status(:no_content)
    end

  end

  context 'checking session valid' do

    it 'replies that session valid when logged in' do
      sign_in user
      get :valid, format: :json
      expect(json_response[:session_valid]).to be(true)
    end

    it 'replies that session invalid when logged out' do
      get :valid, format: :json
      expect(json_response[:session_valid]).to be(false)
    end

  end

end
