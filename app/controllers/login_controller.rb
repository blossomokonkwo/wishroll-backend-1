class LoginController < ApplicationController
  def create
    #this method will be called when a user is logging in. Session should be created.
    @user = User.find_by(email: params[:email])
    if @user and @user.authenticate(params[:password])
      #create session and render it to the client
      payload = {user_id: @user.id}
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      render json: {access: tokens[:access], access_expires_at: tokens[:access_expires_at]} , status: :ok
    else
      render json: {"error" => "Invalid credntials. Please provide a valid email and username"}, status: :unauthorized
    end
  end

  private def login_user_params
    params.permit :email, :password
  end
end
