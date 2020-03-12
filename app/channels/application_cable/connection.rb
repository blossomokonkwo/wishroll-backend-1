module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include JWTSessions::RailsAuthorization 
      
    identified_by :current_user
    def connect
       current_user = get_current_user
       logger.add_tags "Action Cable", "User #{current_user.username}" 
    end

    def disconnect
      
    end
    
    private 
    def get_current_user
      #get the current user else reject the unathourized connection
      User.find(payload["user_id"])
    end




  end
end
