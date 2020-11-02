class NewFeatureMailer < ApplicationMailer
    def keyboard_update
       @user = params[:user]
       mail(to: @user.email, subject: "New WishRoll Keyboard Update!")
    end
    
end
