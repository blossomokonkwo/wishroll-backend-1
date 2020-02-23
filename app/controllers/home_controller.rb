class HomeController < ActionController::Base
    def home
        render :homepage, status: 200
    end
    def what_is_wishroll
        render :whatis, status: 200
    end
    
end