json.array! @activities.each do |activity|
    user = User.select(:username, :profile_picture_url, :is_verified).find(activity.active_user_id)
    cache activity, expires_in: 1.hour do
        json.activity do
            json.happened_at activity.created_at
            json.activity_phrase activity.activity_phrase
            if activity.activity_type == "Post" 
                post = Post.find(activity.content_id)
                json.activity_thumbnail_image post.posts_media_url
            elsif activity.activity_type == "Comment"
                json.activity_thumbnail_image nil
                comment = Comment.find(activity.content_id)
                json.body comment.body
            end
        end
        json.user do 
            json.username user.username
            json.profile_picture_url user.profile_picture_url
            json.is_verified user.is_verified
        end
    end
end
