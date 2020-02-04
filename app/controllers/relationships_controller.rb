class RelationshipsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @followed_user = User.find_by(username: params[:username])
        if @followed_user and @followed_user != current_user and !(current_user.followed_users.include? @followed_user)
            @relationship = current_user.active_relationships.new followed_id: @followed_user.id
            if @relationship.save                
                Activity.create(user_id: @followed_user.id, active_user_id: current_user.id, activity_type: "Relationship", activity_phrase: "#{current_user.username} began following you", content_id: @relationship.id)
                render json: {relationship_id: @relationship.id}, status: :created
            else
                render json: {error: "Your follow request was unsuccessfull"}
            end
        else
            render json: {error: "Something went wrong: The user you are attempting to follow doesn't exist in our records or you are attempting to follow yourself which you can't do or you are already following this user"}, status: 400
        end 
    end

    def destroy
        @unfollwed_user = User.find_by(username: params[:username])
        if @unfollwed_user
            @relationship = Relationship.where(followed_id: @unfollwed_user.id, follower_id: current_user.id).first
            if @relationship
                if @relationship.destroy
                    render json: nil, status: 200
                else
                    render json: {error: "Unable to unfollow #{params[:username]} at this time"}, status: 400
                end
            else
                render json: {error: "The relationship between #{params[:username]} and #{current_user.username} does not exist"}, status: 400
            end
        else
            render json: {error: "Couldn't find the user that you wanted to unfollow"}, status: 400
        end


    end

    
end
