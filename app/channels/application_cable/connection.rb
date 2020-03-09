module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include JWTSessions::RailsAuthorization
    rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
    identified_by :current_user

    def connect
      self.current_user = get_current_user
      logger.add_tags "ActionCable", "User #{current_user.username}"
    end

    protected 
    def get_current_user
        @current_user ||= User.find(payload["user_id"])
    end

    #this method is called whenever an unauthorization occurs
    private
     def not_authorized
        render json: {"error" => "not authorized"}, status: :unauthorized
    end
  end
end
