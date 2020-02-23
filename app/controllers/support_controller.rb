class SupportController < ActionController::Base
    def contact
        render :contact, status: 200
    end
end