class Api::V2::Sessions::LoginController < APIController

  def new
    if @user = User.where(username: params[:access]).or(User.where(email: params[:access])).first and @user.authenticate(params[:password])
        payload = {id: @user.id, username: @user.username}
        session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
        tokens = session.login
        render json: {user: {id: @user.id, username: @user.username, bio: @user.bio != nil ? @user.bio : "", profile_background_url: @user.profile_background_url, verified: @user.verified, email: @user.email, name: @user.name, created_at: @user.created_at, avatar: @user.avatar_url}, access_token: {access: tokens[:access], csrf: tokens[:csrf], access_expires_at: tokens[:access_expires_at]}} , status: :ok
      else
        render json: {error: "Invalid credentials"}, status: :unauthorized
      end   
  end
    
end