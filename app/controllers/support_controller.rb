class SupportController < ActionController::Base
    def contact
        render :contact, status: 200
    end

    def email_us
        @body = params[:email_body]
        @subject = params[:subject]
        @email = params[:email]
        
    end
    
end