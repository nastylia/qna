class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
    # render json: request.env['omniauth.auth']
  end

  def twitter(auth = nil)
    # binding.pry
    auth ||= request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      session["devise.twitter_data"] = auth.except("extra")
      render 'devise/confirmations/confirm_email'
    end
    # render json: request.env['omniauth.auth']
  end

  def confirm_email
    # binding.pry
    auth = OmniAuth::AuthHash.new(session["devise.twitter_data"])
    auth[:info][:email] = params[:email]
    auth[:confirmation] = true
    twitter(auth)
  end

end
