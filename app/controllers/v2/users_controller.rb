class V2::UsersController < ApplicationController
    before_action :authorize_by_access_header!

    def show
        if params[:username]
            @user = User.find_by(username: params[:username])
        elsif params[:id]
            @user =  User.find(params[:id])
        end
        if @user
            if current_user.blocked_users.include?(@user)
                render json: {id: @user.id, can_unblock: true}, status: :forbidden
            elsif @user.blocked_users.include?(@user)
                render json: {id: @user.id, can_unblock: false}, status: :forbidden
            else
                @following = nil
                if current_user.id != @user.id
                    @following = current_user.following?(@user)
                end
                render :show, status: :ok
            end
        else
            render json: {error: "#{params[:username]} does not have an account on WishRoll"}, status: :not_found
        end
    end


    def posts
        @user = User.find(params[:user_id])
        offset = params[:offset] #use the created at field to offset the data
        limit = 18
        if @user
            unless current_user.blocked_users.include?(@user) or @user.blocked_users.include?(current_user)
                @posts = Array.new
                if offset 
                    @posts = @user.created_posts(limit: limit, offset: offset)
                else 
                    @posts = @user.created_posts(limit: limit)
                end
                if @posts.any?
                    @id = current_user.id
                    render :posts, status: :ok
                else
                    render json: {error: "#{params[:username]} doesn't have any posts"}, status: :not_found
                end  
            else
                render json: nil, status: :forbidden
            end

        else
            render json: {error: "#{params[:username]} does not have an account on WishRoll"}, status: :not_found 
        end
    end

    def rolls
        @user = User.find(params[:user_id])
        offset = params[:offset]
        limit = 15
        if @user
            unless current_user.blocked_users.include?(@user) or @user.blocked_users.include?(current_user)
                can_show_private_rolls = @user == current_user
                @rolls = @user.created_rolls(limit: limit, offset: offset, show_private_rolls: can_show_private_rolls)
                if @rolls.any?
                    @id = current_user.id
                    render :rolls, status: :ok
                else
                    render json: {error: "#{params[:username]} doesn't have any posts"}, status: :not_found
                end
            else
                render json: nil, status: :forbidden
            end
        else
            render json: {error: "#{params[:username]} does not have an account on WishRoll"}, status: :not_found 
        end
    end

    def liked_rolls
        @user = User.find(params[:user_id])
        offset = params[:offset]
        limit = 15
        if @user
            unless current_user.blocked_users.include?(@user) or @user.blocked_users.include?(current_user)
                @rolls = @user.liked_rolls(limit: limit, offset: offset)
                if @rolls.any?
                    @id = current_user.id
                    render :liked_rolls, status: :ok
                else
                    render json: {error: "#{params[:username]} doesn't have any liked rolls"}, status: :not_found
                end
            else
                render json: nil, status: :forbidden
            end
        else
            render json: {error: "#{params[:username]} does not have an account on WishRoll"}, status: :not_found 
        end
    end
    
    

    def liked_posts
        @user = User.find(params[:user_id])
        offset = params[:offset]
        limit = 18
        if @user
            unless current_user.blocked_users.include?(@user) or @user.blocked_users.include?(current_user)
                @posts = Array.new
                if offset
                    @posts = @user.liked_posts(limit: limit, offset: offset) #in later versions, there will be an optimization for speed using offset
                else
                    @posts = @user.liked_posts(limit: limit)
                end
                if @posts.any? 
                    @id = current_user.id
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
    
    private def update_params
        params.permit :username, :email, :name, :avatar, :profile_background_media, :bio
    end
    
    
    
end