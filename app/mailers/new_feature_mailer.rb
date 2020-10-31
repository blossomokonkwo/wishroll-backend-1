class NewFeatureMailer < ApplicationMailer
    def keyboard_update
       @user = params[:user]
       mail(to: @user.email, subject: "Keyboard Update!")
    end
    
end
