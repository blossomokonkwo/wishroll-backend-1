class SearchController < ApplicationController
    before_action :authorize_by_access_header!
    def search 
        @id = current_user.id
        @posts = Array.new #we want a collection of UNIQUE posts sent to the clients, therfore we are using the Set Abstract Data Type
        @users = Array.new
        if !params[:query].empty?
            @users = User.where("username ILIKE ?", "#{search_params[:query]}%").order(is_verified: :desc, followers_count: :desc, following_count: :asc).select([:username, :is_verified, :full_name, :profile_picture_url]) 
            .or(User.where("full_name ILIKE ?", "%#{search_params[:query]}%").order(is_verified: :desc, followers_count: :desc, following_count: :asc).select([:username, :is_verified, :full_name, :profile_picture_url]))     
            if params[:query_type] != "User"
                Tag.where("text ILIKE ?", "%#{search_params[:query]}%").limit(5000).includes([:post]).find_each do |tag|
                    @posts << tag.post
                end
            end
            if @posts.empty? and @users.empty?
                render json: nil, status: 404
            else

                render :index, status: :ok
            end
        else
            render json: nil, status: 404
        end
    end
    #v2: in version 2 of the WishRoll api, we search for models using specific controller actions instead of using just one action
    def search_posts
        @id = current_user.id
        limit = 15
        offset = params[:offset]
        @posts = Post.left_outer_joins(:tags).where("text ILIKE ?", "%#{search_params[:query]}%").order(likes_count: :desc, view_count: :desc, created_at: :desc, id: :asc).offset(offset).limit(limit)
        @posts.to_a.delete_if do |post|
            current_user.reported_posts.include?(post)
        end
        if @posts.any?
            render :index_posts, status: 200
        else
            render json: nil, status: 404
        end
    end

    def search_accounts
        @id = current_user.id
        limit = 15
        offset = params[:offset]
        @users = User.where("username ILIKE ? OR full_name ILIKE ?", "%#{search_params[:query]}%", "%#{search_params[:query]}%").select([:username, :is_verified, :full_name, :profile_picture_url]).order(is_verified: :desc, followers_count: :desc, following_count: :asc, id: :asc).offset(offset).limit(limit)
        #filter the returned users to ensure that users who are blocked do not interact with each other
        @users.to_a.delete_if do |user|
            #if a user is blcoked by the current user or the current user is blocked by the other user, then we remove them from the array
            user.blocked_users.include?(current_user) or current_user.blocked_users.include?(user)
        end
        if @users.any? 
            render :index_users, status: 200
        else
            render json: nil, status: 404
        end
    end

    def search_followers
        offset = params[:offset]
        @user = User.find_by(username: params[:username])
        @current_user = current_user
        limit = 10
        @users = @user.follower_users.where("username ILIKE ? OR full_name ILIKE ?", "%#{search_params[:query]}%", "%#{search_params[:query]}%").order(is_verified: :desc, followers_count: :desc, following_count: :asc).select([:username, :is_verified, :full_name, :profile_picture_url, :created_at]).limit(limit).offset(offset)
        if @users.any?
            render :index_followers, status: 200
        else
            render json: nil, status: 404
        end
    end 

    def search_followed_users
        offset = params[:offset]
        limit = 10
        @current_user = current_user
        @user = User.find_by(username: params[:username])
        @users = @user.followed_users.where("username ILIKE ? OR full_name ILIKE ?", "%#{search_params[:query]}%", "%#{search_params[:query]}%").order(is_verified: :desc, followers_count: :desc, following_count: :asc).select([:username, :is_verified, :full_name, :profile_picture_url, :created_at]).offset(offset).limit(limit)
        if @users.any?
            render :index_followed_users, status: 200
        else
            render json: nil, status: 404
        end
    end

    def search_chat_room_users
        offset = params[:offset]
        limit = 15
        @chat_room_users = ChatRoomUser.where(chat_room_id: params[:chat_room_id]).select(:user_id).joins(:user).where("username ILIKE ? OR full_name ILIKE ?", "%#{search_params[:query]}%", "%#{search_params[:query]}%").includes([:user]).limit(limit).offset(offset)
        if @chat_room_users.any?
            render :chat_room_users_index, status: 200
        else
            render json: nil, status: 404
        end
    end

    def search_chat_rooms
        offset = params[:offset]
        limit = 15
        @chat_rooms = ChatRoom.where("name ILIKE ?", "%#{search_params[:query]}%").select(:name).order(num_users: :desc, created_at: :desc).limit(limit).offset(offset)
        if @chat_rooms.any?
            render :chat_rooms_index, status: 200
        else
            render json: nil, status: 404
        end
    end

    def search_topics
        offset = params[:offset]
        limit = 15
        @topics = Topic.where("title ILIKE ?", "%#{search_params[:query]}%").select([:title, :media_url]).order(hot_topic: :desc, created_at: :asc).limit(limit).offset(offset)
        if @topics.any?
            render :topics_index, status: 200
        else
            render json: nil, status: 404
        end
    end

    private 
    def search_params
        params.permit :query, :query_type, :offset, :username, :chat_room_id
    end
end
