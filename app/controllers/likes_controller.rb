class LikesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        #the client must ensure that a user can only send a like request once. 
        #This can be done by creating a client side boolean that determines 
        #whether or not a user has already liked a specific content
            case params[:likeable_type]
            when "Comment"
                comment = Comment.find(params[:likeable_id])
                if !((comment.likes.to_a.bsearch do |like| like.user_id == current_user.id end).present?)
                    like = Like.new(user_id: current_user.id, likeable_type: params[:likeable_type], likeable_id: params[:likeable_id])
                    like.save
                    user_id = User.select(:id).find(comment.user_id).id
                    if current_user.id != user_id            
                        content_id = comment.id
                        activity_type = params[:likeable_type]
                        activity_phrase = nil
                        if comment.original_comment_id
                            activity_phrase = "#{current_user.username} liked your reply"
                        else
                            activity_phrase = "#{current_user.username} liked your comment"
                        end
                        post_image_url = Post.find(comment.post_id).media_url
                        if Activity.find_by(user_id: user_id, active_user_id: current_user.id, activity_type: activity_type, media_url: post_image_url) == nil
                            activity = Activity.new(user_id: user_id, active_user_id: current_user.id, activity_phrase: activity_phrase, content_id: content_id, activity_type: activity_type, media_url: post_image_url)
                            activity.save
                        end #it is crucial that the activity object is saved and persisted on the DB
                        render json: nil, status: 200
                    end
                else
                    render json: {error: "You have already liked this comment"}, status: 400
                end
            when "Post"
                post = Post.find(params[:likeable_id])
                if !((post.likes.to_a.bsearch do |like| like.user_id == current_user.id end).present?) #run a bsearch on all the likes that belong to a comment to check if that like already exists 
                    like = Like.new(user_id: current_user.id, likeable_type: params[:likeable_type], likeable_id: params[:likeable_id])
                    like.save
                    user_id = User.select(:id).find(post.user_id).id
                    if current_user.id != user_id
                        content_id = post.id
                        activity_type = params[:likeable_type]
                        if post
                            activity_phrase = "#{current_user.username} liked your post"
                            post_image_url = post.media_url
                        end
                        if Activity.find_by(user_id: user_id, active_user_id: current_user.id, activity_type: activity_type, media_url: post_image_url) == nil
                            activity = Activity.new(user_id: user_id, active_user_id: current_user.id, activity_phrase: activity_phrase, content_id: content_id, activity_type: activity_type, media_url: post_image_url)
                            activity.save
                        end #it is crucial that the activity object is saved and persisted on the DB
                    end
                    render json: nil, status: 200
                else
                    render json: {error: "You have already liked this post"}, status: 400
                end
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
