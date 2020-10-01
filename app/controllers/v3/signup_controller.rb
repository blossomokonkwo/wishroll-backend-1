class V3::SignupController < ApplicationController
    require 'securerandom'
    def new
        @user = User.new(email: params[:email], password: params[:password], username: "user#{SecureRandom.hex(10)}")
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