class LikesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        #the client must ensure that a user can only send a like request once. 
        #This can be done by creating a client side boolean that determines 
        #whether or not a user has already liked a specific content
        like = Like.new(user_id: current_user.id, likeable_type: params[:likeable_type], likeable_id: params[:likeable_id])
        if like.save
            user = nil #this is the user who's content was liked. This users id will be referenced by the newly instantiated activity object's user_id
            activity_phrase = nil
            content_id = nil
            activity_type = nil
            case params[:likeable_type]
            when "Comment"
                comment = Comment.find(params[:likeable_id])
                user = User.find(comment.user_id).id
                content_id = comment.id
                activity_type = "Comment"
                if comment.original_comment_id
                    activity_phrase = "#{current_user.username} liked your reply"
                else
                    activity_phrase = "#{current_user.username} liked your comment"
                end
            when "Post"
                post = Post.find(params[:likeable_id])
                user = User.find(post.user_id).id
                content_id = post.id
                activity_type = "Post"
                if post.original_post_id
                    activity_phrase = "#{current_user.username} liked your reaction"
                else
                    activity_phrase = "#{current_user.username} liked your post"
                end
            else
                #this case should only occur if more content can be likeable and this switch/case statement isn't updated
                #other than that this is an error
            end
            activity = Activity.new(user_id: user, active_user_id: current_user.id, activity_phrase: activity_phrase, content_id: content_id, activity_type: activity_type)
            activity.save #it is crucial that the activity object is saved and persisted on the DB
            render json: nil, status: 200
        else
            render json: {error: "There was an error processing the request"}
        end
    end

    def destroy
        #The client must ensure that a user can only send an like request once. 
        like = Like.find_by(user_id: current_user.id,likeable_id: params[:likeable_id])
        if like.destroy
            render json: nil, status: 200
        else
            render json: {error: "There was an error with the request"}, status: 400
        end
    end
end
