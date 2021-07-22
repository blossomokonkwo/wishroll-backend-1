class Api::V2::UsersController < APIController
    before_action :authorize_by_access_header!

    def show
        # if params[:username]
        #     @user = User.fetch_by_username(params[:username])
        # elsif params[:id]
        #     @user =  User.fetch(params[:id])
        # end
        if @user = (User.fetch_by_username(params[:username]) or User.fetch(params[:id]))
            if current_user.blocked?(@user)
                render json: {id: @user.id, can_unblock: true}, status: :forbidden
            elsif @user.blocked?(current_user)
                render json: {id: @user.id, can_unblock: false}, status: :forbidden
            else
                # @following = current_user.following?(@user) if current_user.id != @user.id
                render :show, status: :ok
            end
        else
            render json: {error: "Not Found"}, status: :not_found
        end
    end

    def posts
        @user = User.fetch(params[:user_id])
        offset = params[:offset] #use the created at field to offset the data
        limit = 18
        if @user
            unless current_user.blocked?(@user) or @user.blocked?(current_user)
                @posts = Array.new
                if offset 
                    @posts = @user.created_posts(limit: limit, offset: offset, reported_posts: current_user.reported_posts).to_a
                else 
                    @posts = @user.created_posts(limit: limit, reported_posts: current_user.reported_posts).to_a
                end
                if @posts.any?
                    @current_user = current_user
                    render :posts, status: :ok
                else
                    render json: nil, status: :not_found
                end  
            else
                render json: nil, status: :forbidden
            end

        else
            render json: nil, status: :not_found 
        end
    end

    def rolls
        @user = User.fetch(params[:user_id])
        offset = params[:offset]
        limit = 12
        if @user 
            unless current_user.blocked?(@user) or @user.blocked?(current_user)
                @rolls = @user.created_rolls(limit: limit, offset: offset).to_a
                if @rolls.any?
                    @current_user = current_user
                    render :rolls, status: :ok
                else
                    render json: nil, status: :not_found
                end
            else
               render json: nil, status: :forbidden 
            end
        else
            render json: nil, status: :not_found
        end
    end

    def liked_rolls
        if @user = User.fetch(params[:user_id])
            offset = params[:offset]
            limit = 18
            unless current_user.blocked?(@user) or @user.blocked?(current_user)
                @rolls = @user.liked_rolls(limit: limit, offset: offset).to_a
                if @rolls.any?
                    @current_user = current_user
                    render :liked_rolls, status: :ok
                else 
                    render json: nil, status: :not_found
                end
            end
        else 
            render json: {error: "Couldn't find user with id #{params[:user_id]}"}, status: :not_found
        end
    end

    def liked_posts
        @user = User.fetch(params[:user_id])
        offset = params[:offset]
        limit = 18
        if @user
            unless current_user.blocked?(@user) or @user.blocked?(current_user)
                @posts = Array.new
                if offset
                    @posts = @user.liked_posts(limit: limit, offset: offset).to_a 
                else
                    @posts = @user.liked_posts(limit: limit).to_a
                end
                if @posts.any? 
                    @current_user = current_user
                    render :liked_posts, status: :ok
                else
                    render json: {error: "#{params[:username]} hasn't liked any posts"}, status: :not_found
                end  
            else
                render json: nil, status: :forbidden
            end

        else
            render json: {error: "#{params[:username]} does not have an account on WishRoll"}, status: :not_found 
        end
    end

    def current_user_created_posts
        offset = params[:offset]
        limit = 15
        @posts = current_user.created_posts(limit: limit, offset: offset)
        if @posts.any?
            @current_user = current_user
            render :current_user_posts, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    def current_user_liked_posts
        offset = params[:offset]
        limit = 15
        @posts = current_user.liked_posts(limit: limit, offset: offset)
        if @posts.any?
            @current_user = current_user
            render :current_user_posts, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    def current_user_bookmarked_posts
        offset = params[:offset]
        limit = 15
        @posts = current_user.bookmarked_posts(limit: limit, offset: offset)
        if @posts.any?
            @current_user = current_user
            render :current_user_posts, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    def update
        begin
            current_user.update!(update_params)
            if params[:avatar] and current_user.avatar.attached?
                current_user.update!(avatar_url: url_for(current_user.avatar))
            end
            if params[:profile_background_media] and current_user.profile_background_media.attached?
                current_user.update!(profile_background_url: url_for(current_user.profile_background_media))
            end
            render json: {current_user: {username: current_user.username, email: current_user.email, name: current_user.name, bio: current_user.bio, avatar_url: current_user.avatar_url, profile_background_url: current_user.profile_background_url}}, status: :ok
        rescue 
            render json: {error: "An error occured when updating the current user's account"}, status: 500
        end
    end

    def destroy        
        if current_user.id == params[:id].to_i and current_user.destroy
            session = JWTSessions::Session.new(refresh_by_access_allowed: true, payload: claimless_payload)
            session.flush_by_access_payload
            render json: nil, status: :ok            
        else
            render json: {error: "Couldn't delete account"}, status: 500            
        end
    end

    private def update_params
        params.permit :username, :email, :name, :avatar, :profile_background_media, :bio
    end
    
    
    
end