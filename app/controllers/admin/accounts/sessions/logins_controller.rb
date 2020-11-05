class Admin::Accounts::Sessions::LoginsController < AdminController
    def create
        #the admin user authenticates by providing their email and password associated with their account
        if @admin_user = AdminUser.find_by(email: params[:email]) and @admin_user.authenticate(params[:password])
            payload = {id: @admin_user.id, admin_username: @admin_user.admin_username}
            session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
            tokens = session.login
            render json: {admin_user: {id: @admin_user.id, admin_username: @admin_user.admin_username, bio: @admin_user.bio != nil ? @admin_user.bio : "", profile_background_url: @admin_user.profile_background_url, verified: @admin_user.verified, email: @admin_user.email, name: @admin_user.name, created_at: @admin_user.created_at, avatar: @admin_user.avatar_url}, access_token: {access: tokens[:access], csrf: tokens[:csrf], access_expires_at: tokens[:access_expires_at]}} , status: :ok
        else
            render json: {error: "Invalid credentials"}, status: :unauthorized
        end 
    end
    
end