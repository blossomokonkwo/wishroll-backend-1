class ApplicationController < ActionController::API
    include JWTSessions::RailsAuthorization
    rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

    def current_user
        @current_user ||= User.find(payload[:user_id])
    end

    #this method is called whenever an unauthorization occurs
    private def not_authorized
        render json: {"error": "not authorized"}, status: :unauthorized
    end
    
end
