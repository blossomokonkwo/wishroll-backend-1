json.array! @activities.each do |activity|
    user = activity.active_user
    cache activity, expires_in: 1.minute do
        json.id activity.id
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
                json.shares post.share_count
                json.comments_count post.comments_count
                json.views post.view_count
                json.viewed post.viewed?(@id)
                json.liked post.liked?(@id)
                json.created_at post.created_at
                json.updated_at post.updated_at
                json.creator do
                    user = post.user
                    json.id user.id
                    json.username user.username
                    json.avatar user.avatar_url
                    json.verified user.verified
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
                json.shares post.share_count
                json.comments_count post.comments_count
                json.views post.view_count
                json.viewed post.viewed?(@id)
                json.liked post.liked?(@id)
                json.created_at post.created_at
                json.updated_at post.updated_at
                json.creator do
                    user = post.user
                    json.id user.id
                    json.username user.username
                    json.avatar user.avatar_url
                    json.verified user.verified
                end
            end
        end
        json.user do 
            json.id user.id
            json.username user.username
            json.avatar user.avatar_url
            json.verified user.verified
        end
    end
end
