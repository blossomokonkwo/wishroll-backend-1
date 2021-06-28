class Api::V1::Registration::SignupController < APIController
    def validate_email  
        email = params[:email]      
        if User.find_by(email: email)
            render json: {error: "This email is already in use with another account: #{email}"}, status: :bad_request
        else
            render json: {success: "This email is available to use with account registration: #{email}"}, status: :accepted
        end
    end

    def validate_username  
        username = params[:username]      
       if User.find_by(username: username)
            render json: {error: "This username is already in use with another account: #{username}"}, status: :bad_request
        else
            render json: {success: "This username is available to use with account registration: #{username}"}, status: :accepted
        end
    end


    def new
        @user = User.new(email: params[:email], password: params[:password], username: params[:username], name: params[:name], birth_date: params[:birth_date], gender: params[:gender] || 2)
        if @user.save 
            payload = {id: @user.id, username: @user.username}
            session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
            tokens = session.login
            render json: {user: {id: @user.id, username: @user.username, verified: @user.verified, email: @user.email, name: @user.name, avatar: @user.avatar_url, created_at: @user.created_at}, access_token: {access: tokens[:access], csrf: tokens[:csrf], :access_expires_at => tokens[:access_expires_at]}}, status: :created            
        else 
            render json: @user.errors, status: :bad_request
        end
    end
end