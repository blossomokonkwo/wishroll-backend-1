class ApplicationController < ActionController::API
    include JWTSessions::RailsAuthorization
    rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

    def current_user
        @current_user ||= User.current_user(payload["user_id"] || payload["id"])
    end

    #this method is called whenever an unauthorization occurs
    private def not_authorized
        if request.url == "https://www.wishroll.co/" or request.url == "https://www.wishroll-testing.herokuapp.com/" or request.url == "http://127.0.0.1:3000/" or request.url == "http://localhost:3000/"
            redirect_to "/home"
        else
            render json: {"error" => "not authorized"}, status: :unauthorized
        end
    end
    
end
