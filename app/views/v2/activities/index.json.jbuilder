json.array! @activities.each do |activity|
    user = activity.active_user
    cache activity, expires_in: 1.minute do
        json.created_at activity.created_at
        json.phrase activity.activity_phrase
        json.thumbnail_url activity.media_url
        json.type activity.activity_type
        if activity.activity_type == "Comment"
            comment = Comment.find(activity.content_id)
            json.body comment.body
        end
        if activity.activity_type == "Post"
            post = Post.find(activity.content_id)
            json.post do
                json.id post.id
                json.media_url post.media_url
                json.caption post.caption
                json.thumbnail_url post.thumbnail_url
                json.likes post.likes_count
                json.comments_count post.comments_count
                json.views post.view_count
                json.created_at post.created_at
                json.updated_at post.updated_at
                json.user do
                    user = post.user
                    json.username user.username
                    json.avatar user.avatar_url
                    json.verified user.verified
                end
                json.tags post.cached_tags.each do |t|
                    json.id t.id
                    json.text t.text
                end                
            end
        elsif activity.activity_type == "Comment"
            post = Comment.find(activity.content_id).post
            json.post do
                json.id post.id
                json.media_url post.media_url
                json.caption post.caption
                json.thumbnail_url post.thumbnail_url
                json.likes post.likes_count
                json.comments_count post.comments_count
                json.views post.view_count
                json.created_at post.created_at
                json.updated_at post.updated_at
                json.user do
                    user = post.user
                    json.username user.username
                    json.avatar user.avatar_url
                    json.verified user.verified
                end
                json.tags post.cached_tags.each do |t|
                    json.id t.id
                    json.text t.text
                end
            end
        end
        json.user do 
            json.username user.username
            json.avatar user.avatar_url
            json.verified user.verified
        end
    end
end
