require 'rails_helper'

RSpec.describe SessionsController do
  let(:user) { User.create(id: 1, email: 'me@mail.com') }

  describe '#create' do
    it 'creates user session for whitelisted email address' do 
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({ 'provider' => 'google_oauth2',
                                                                            'info' => {
                                                                              'email' => user.email
                                                                            },                                                                     
                                                                          })

      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
      get :create, params: { provider: 'google_oauth2' }
      expect(session[:user_id]).to eq(user.id)
    end

    it 'fails to create user session for random email address' do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({ 'provider' => 'google_oauth2',
                                                                           'info' => {
                                                                             'email' => 'random@mail.com'
                                                                            },                                                                     
                                                                          })

      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
      get :create, params: { provider: 'google_oauth2' }
      expect(session[:user_id]).to be nil
    end
  end

  describe '#destroy' do
    it 'logs out user' do
      session[:user_id] = user.id
      delete :destroy
      expect(session[:user_id]).to be nil
    end
  end

  describe '#failure' do
  it 'redirects to root_path on omniauth error' do
    get :failure, params: {"message"=>"access_denied", "origin"=>"http://localhost:3000/", "strategy"=>"google_oauth2"}
    expect(response).to redirect_to(root_path)
  end
end
end