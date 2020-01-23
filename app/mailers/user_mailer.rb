class UserMailer < ApplicationMailer
    default from: "gboyokonkwo@gmail.com"

    def welcome_email
        @user = params[:user]
        mail(to: @user.email, subject: "Welcome to the React app")
    end
end
