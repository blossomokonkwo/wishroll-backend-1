class LoginController < ApplicationController
  def create
    #this method will be called when a user is logging in. Session should be created.
    @user = User.where(username: params[:access]).or(User.where(email: params[:access])).first
    if @user and @user.authenticate(params[:password])
      #create session and render it to the client
      #the users username, verification status, email, profile_picture, and name are returned via the payload
      payload = {user_id: @user.id, username: @user.username, is_verified: @user.is_verified, email: @user.email, full_name: @user.full_name, profile_picture: url_for(@user.profile_picture) if @user.profile_picture.attached?}
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      render json: {bio: @user.bio, access: tokens[:access], csrf: tokens[:csrf], access_expires_at: tokens[:access_expires_at]} , status: :ok
    else
      response["Unauthorized"] = "Invalid credntials. Please provide a valid email and password"
      render json: {error: "Invalid credentials"}, status: :unauthorized
    end
  end
end
