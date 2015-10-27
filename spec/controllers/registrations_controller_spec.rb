# rubocop:disable Metrics/LineLength
require 'rails_helper'

describe RegistrationsController do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  it 'allows user to signup with valid email and password' do
    post :create, format: :json, user: { email: 'test+label@test.com', password: '12345678', password_confirmation: '12345678' }
    expect(response).to be_success
    expect(json_response[:email]).to eql('test+label@test.com')
    expect(User.last.email).to eql('test+label@test.com')
  end

  it 'strips excess spaces from email' do
    post :create, format: :json, user: { email: '  test@test.com ', password: '12345678', password_confirmation: '12345678' }
    expect(User.last.email).to eql('test@test.com')
  end

  it 'requires that the password is at least 8 characters' do
    post :create, format: :json, user: { email: 'test@test.com', password: '1234567', password_confirmation: '1234567' }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_response[:errors][:password].first).to match(/too short/)
  end

  it 'requires that the password and password_confirmation match' do
    post :create, format: :json, user: { email: 'test@test.com', password: '12345678', password_confirmation: '12345679' }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_response[:errors][:password_confirmation].first).to match(/doesn't match/)
  end

  it 'requires a valid email' do
    post :create, format: :json, user: { email: 'test', password: '12345678', password_confirmation: '12345678' }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_response[:errors][:email].first).to match(/is invalid/)
  end
end
