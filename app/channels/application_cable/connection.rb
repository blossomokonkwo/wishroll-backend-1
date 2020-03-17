module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include JWTSessions::RailsAuthorization 
      
    identified_by :current_user
    def connect
       self.current_user = get_current_user
       logger.add_tags "Action Cable", "User #{self.current_user.username}" 
    end

    def disconnect
      
    end
    
    protected 
    def get_current_user
      #get the current user else reject the unathourized connection
        current_user =  User.find(request.headers["cookie"])
        if current_user.present?
          return current_user
        else
          reject_unauthorized_connection
        end
    end




  end
end
