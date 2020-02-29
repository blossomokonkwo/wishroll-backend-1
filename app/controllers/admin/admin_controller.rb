module Admin
    class AdminController < ActionController::API
        #the base controller is used by both the admin and the application namespace
        def index
            render "admin/index.html.erb", status: 200
        end
    end  
end
