class TermsController < ActionController::API
    def terms
        render :terms, status: 200
    end
    
end