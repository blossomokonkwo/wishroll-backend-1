class LoginController < ApplicationController
  def create
    #this method will be called when a user is logging in. Session should be created.
    @user = User.find_by(username: params[:username])
    if @user and @user.authenticate(params[:password])
      #create session and render it to the client
      payload = {user_id: @user.id}
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      render json: {access: tokens[:access], csrf: tokens[:csrf], access_expires_at: tokens[:access_expires_at]} , status: :ok
    else
      response["Unauthorized"] = "Invalid credntials. Please provide a valid email and password"
      render json: {error: "Invalid credentials"}, status: :unauthorized
    end
  end
end
