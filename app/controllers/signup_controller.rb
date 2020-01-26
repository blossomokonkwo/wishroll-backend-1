class SignupController < ApplicationController
    def validate_email
        #validates that the users intended email is unique; if the email is taken, a 400 bad request status is returned else a 200 ok status is returned
        user = User.find_by(email: params[:email])
        if user 
            render json: {error: "That email is already in use with another account"}, status: 400
        else
            render json: nil, status: 200
        end
    end

    def validate_username
        #validates that the users intended username is unique; if the username is taken, a 400 bad request status is returned else a 200 ok status is returned
        username = User.find_by(username: params[:username])
        if username
            render json: {error: "That username has already been taken"}, status: 400
        else
            render json: nil, status: 200
        end
    end

    def new
        @user = User.new(create_account_user_params) #create user w strong params
        if @user.save #if the user is saved to the DB create tokens and send to client
            payload = {user_id: @user.id}
            session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
            tokens = session.login
            render json: {access: tokens[:access], csrf: tokens[:csrf], :access_expires_at => tokens[:access_expires_at]}, status: :created
        else #if the user isn't saved, return the appropriate error messages to the client
            render json: @user.errors, status: 400
        end
    end


    private 
    def create_account_user_params #checks that the user has entered their neccessary credetnitals
        params.permit :email, :password, :username, :first_name, :last_name, :birth_date
    end
    
end
