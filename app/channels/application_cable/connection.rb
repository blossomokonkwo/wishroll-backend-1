module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include JWTSessions::RailsAuthorization
    identified_by :current_user
    def connect
       
    end

    def disconnect
      
    end
    
    
  end
end
