class SignupController < ApplicationController
    def new
        @user = User.new(create_account_user_params) #create user w strong params
        if @user.save #if the user is saved to the DB create tokens and send to client
            payload = {user_id: @user.id}
            session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
            render json: session.login, status: :ok
        else #if the user isn't saved, return the appropriate error messages to the client
            errors = @user.errors
            render json: errors.messages
        end
    end


    private 
    def create_account_user_params #checks that the user has entered their neccessary credetnitals
        params.permit :email, :password, :first_name, :last_name, :bio
    end
    
end
