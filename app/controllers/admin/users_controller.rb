module Admin
    class UsersController < Admin::AdminController 
        after_action :update_profile_picture, only: :update
        def create
            @user = User.new(create_user)
            if @user.save
                render json: nil, status: :created
            else
                render json: {error: "The user could not be created"}, status: 400
            end
        end

        def update
            @user = User.find(params[:id])
            if @user 
                @user.update(update_user)
                if @user.save
                    render :show, status: :ok
                else
                    render json: {error: "User could not be updated"}, status: 400
                end
            else
                render json: {error: "User could not be found"}, status: :not_found
            end
        end

        def update_password
            @user = User.find(params[:id])
            if @user 
                @user.password = params[:new_password]
                if @user.save
                render json: {success: "Password has been successfully updated"}, status: :ok
                else
                    render json: {error: "Unable to update the users password"}, status: 400
                end
            else
                render json: {error: "The user doesn't exist"}, status: 404
            end
        end
        
        #users can update their username. If the new requested username is already taken, a 400 response is returned to the client
        def update_username
            @user = User.find(params[:id])
            if @user
                @user.username = params[:username]
                if @user.save
                render json: {success: "Username has successfully been updated"}, status: :ok
                else
                render json: {error: "The username could not be updated"}, status: 400
                end
            else
                render json: {error: "The user doesn't exist"}, status: 404
            end
        end
        
        def update_name
            @user = User.find(params[:id])
            if @user
                @user.first_name = params[:first_name]
                @user.last_name = params[:last_name]
                if @user.save
                render json: {success: "The users name has been updated!"}, status: :ok
                else
                render json: {error: "The users name could not be updated!"}, status: 400
                end
            else
                render json: {error: "The user doesn't exist"}, status: 404
            end
        end
        
        def update_bio
            @user = User.find(params[:id])
            if @user
                @user.bio = params[:bio]
                if @user.save
                render json: {success: "The users bio has been updated"}, status: :ok
                else
                render json: {error: "The users bio has been updated"}, status: 400
                end
            else 
                render json: {error: "The user doesn't exist"}, status: 404
            end
        end
        
        def destroy
            @user = User.find(params[:id])
            if @user
                if @user.destroy
                render json: {success: "The users account has been successfully deleted"}, status: :ok
                else
                render json: {error: "The users account could not be deleted"}, status: 400
                end
            else
                render json: {error: "The user doesn't exist"}, status: 404
            end
        end

        def index
            @users = User.all
            render "admin/users/index.json.jbuilder", status: :ok
        end

        def show
            @user = User.find(params[:id])
            if @user 
                render :show, status: :ok
            else
                render json: {error: "User doesn't exist"}, status: :not_found
            end
        end
        
        

        private 
        def create_user
            params.permit :username, :email, :is_verified, :password, :birth_date, :first_name, :last_name
        end

        def update_user
            params.permit :username, :email, :is_verified, :profile_picture
        end

        def update_profile_picture
            current_user.profile_picture_url = url_for(current_user.profile_picture) if current_user.profile_picture.attached?
          end
    end
        
end