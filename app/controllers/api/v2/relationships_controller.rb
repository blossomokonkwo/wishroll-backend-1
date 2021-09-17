class Api::V2::RelationshipsController < APIController
    before_action :authorize_by_access_header!


    def follow
        @user = User.find(params[:user_id])
        begin
            unless @user.blocked?(current_user) or current_user.blocked?(@user)
                unless Relationship.find_by(followed_id: @user.id, follower_id: current_user.id)
                    relationship = Relationship.create!(followed_id: @user.id, follower_id: current_user.id)
                    RelationshipActivityJob.perform_now(follower_user_id: current_user.id, followed_user_id: @user.id, relationship_id: relationship.id)
                    render json: {success: "Successfully following #{@user.username}"}, status: :created
                else
                    render json: {error: "#{current_user.username} is already following #{@user.username}"}, status: :bad_request
                end
            else
                render json: {error: "#{current_user.username} can't follow #{@user.username} because the #{@user.username} has blocked #{current_user.username}"}, status: :forbidden
            end

        rescue => exception
            render json: {error: "An error occured that prevents #{current_user.username} from following #{@user.username}"}, status: :bad_request
        end
    end

    def unfollow
        @user = User.find(params[:user_id])
        begin
            relationship = Relationship.find_by(followed_id: @user.id, follower_id: current_user.id)
            if relationship.destroy
                render json: {success: "Successfully unfollowed #{@user.username}"}, status: :ok
            else
                render json: {error: "An error occured that prevents #{current_user.username} from unfollowing #{@user.username}"}, status: :bad_request 
            end
        rescue => exception
            render json: {error: "An error occured that prevents #{current_user.username} from unfollowing #{@user.username}"}, status: :bad_request
        end
    end
    
    

    def followers
        offset = params[:offset]
        limit = 12
        @current_user = current_user
        @user = User.fetch(params[:user_id])
        if @user
            @current_user = current_user
            @followers = Array.new
            if offset
                @followers = @user.follower_users.order('relationships.created_at DESC').offset(offset).order(id: :desc).limit(limit).to_a
            else
                @followers = @user.follower_users.order('relationships.created_at DESC').limit(limit).to_a
            end
            if @followers.any?
                render :followers, status: :ok
            else
                render json: nil, status: :not_found
            end 
        else
            render json: {error: "#{params[:username]} doesn't have an account on WishRoll"}, status: :not_found
        end
    end
    

    def following
        offset = params[:offset]
        limit = 12
        @user = User.fetch(params[:user_id])
        if @user
            @current_user = current_user
            @followed_users = Array.new
            if offset
                @followed_users = @user.followed_users.offset(offset).order('relationships.created_at DESC').limit(limit).to_a
            else
                @followed_users = @user.followed_users.order('relationships.created_at DESC').limit(limit).to_a
            end
            if @followed_users.any?
                render :following, status: :ok
            else
                render json: nil, status: :not_found
            end 
        else
            render json: {error: "#{params[:username]} doesn't have an account on WishRoll"}, status: :not_found
        end
    end


    def block
        if @blocked_user = User.find(params[:user_id])
            if current_user != @blocked_user

                if @current_user.following?(@blocked_user)
                    Relationship.find_by(followed_id: @blocked_user.id, follower_id: current_user.id).destroy
                elsif @blocked_user.following?(current_user)
                    Relationship.find_by(followed_id: current_user.id, follower_id: @blocked_user.id).destroy
                end
                # Destroy any mutual relationships when blocking a user
                if mutual_relationship = MutualRelationship.find_by("(mutual_id = #{@blocked_user.id} AND user_id = #{current_user.id}) OR (mutual_id = #{current_user.id} AND user_id = #{@blocked_user.id})")
                    mutual_relationship.destroy
                end

                if !current_user.blocked?(@blocked_user)
                    current_user.blocked_users << @blocked_user
                    render json: nil, status: :ok
                else
                    render json: {error: "#{params[:username]} is already blocked by #{current_user.username}"}, status: :bad_request
                end

            else
                render json: {error: "Unable to fulfill request. Cannot block a current user."}, status: :bad_request
            end
        else
            render json: {error: "#{params[:username]} doesn't have an account on WishRoll"}, status: :not_found
        end
    end


    def unblock
        @blocked_user = current_user.blocked_users.find_by(id: params[:user_id])
        if @blocked_user
            if current_user != @blocked_user
                BlockRelationship.find_by(blocked_id: @blocked_user.id, blocker_id: current_user.id).destroy
                render json: nil, status: :ok
            else
                render json: {error: "Unable to fulfill request. Cannot block a current user."}, status: :bad_request
            end
        else
            render json: {error: "#{params[:username]} isn't blocked by #{current_user.username}"}, status: :bad_request
        end
    end
    
    def blocked_users
        @blocked_users = current_user.blocked_users.to_a
        if @blocked_users.any?
            render :blocked_users, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
    
end