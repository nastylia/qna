module ControllerMacros
  def sign_in_user(user)
    before do
      @user = user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end