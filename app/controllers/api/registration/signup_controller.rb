class Api::Registration::SignupController < APIController
    def validate_email        
        if User.find_by(email: params[:email])
            render json: {error: "That email is already in use with another account"}, status: :bad_request
        else
            render json: nil, status: :ok
        end
    end

    def validate_username        
       if User.find_by(username: params[:username])
            render json: {error: "That username has already been taken"}, status: :bad_request
        else
            render json: nil, status: :ok
        end
    end


    def new
        @user = User.new(email: params[:email], password: params[:password], username: params[:username], name: params[:name], birth_date: params[:birth_date], gender: params[:gender] || 2)
        if @user.save 
            payload = {id: @user.id, username: @user.username}
            session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
            tokens = session.login
            render json: {user: {id: @user.id, username: @user.username, verified: @user.verified, email: @user.email, name: @user.name, avatar: @user.avatar_url, created_at: @user.created_at}, access_token: {access: tokens[:access], csrf: tokens[:csrf], :access_expires_at => tokens[:access_expires_at]}}, status: :created
            CreateLocationJob.perform_now(params[:ip_address] || request.remote_ip, params[:timezone], @user.id, @user.class.name)
        else 
            render json: @user.errors, status: :bad_request
        end
    end
end