class UserMailer < ApplicationMailer
    default from: "support@wishroll.co"

    def welcome_email
        @user = params[:user]
        mail(to: @user.email, subject: "Welcome to the WishRoll")
    end 



    def update_email
        User.all.find_each do |user|
            mail(to: user.email, subject: "We've got exciting news for you!")
        end
    end
end
