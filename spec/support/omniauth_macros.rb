module OmniauthMacros
  def twitter_mock
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      :provider => 'twitter',
      :uid => '123456',
      :info => {
        :email => ''
      },
      :credentials => {
        :token => 'mock_token',
        :secret => 'mock_secret'
      }
    })
  end

  def facebook_with_email_mock
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123456',
      :info => {
        :email => 'test@email.com',
      },
      :credentials => {
        :token => 'mock_token',
        :secret => 'mock_secret'
      }
    })
  end
end
