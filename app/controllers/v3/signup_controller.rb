class V3::SignupController 
    require 'securerandom'
    def new
        @user = User.new(email: params[:email], password: params[:password], username: "user#{SecureRandom.alphanumeric(10)}") #create user w strong params
        if @user.save #if the user is saved to the DB create tokens and send to client
            payload = {user_id: @user.id, username: @user.username, is_verified: @user.verified, email: @user.email, full_name: @user.name, profile_picture: @user.avatar_url}
            session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
            tokens = session.login
            render json: {access: tokens[:access], csrf: tokens[:csrf], :access_expires_at => tokens[:access_expires_at]}, status: :created
        else #if the user isn't saved, return the appropriate error messages to the client
            render json: @user.errors, status: 400
        end
    end
end