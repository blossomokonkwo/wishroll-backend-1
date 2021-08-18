json.array! @activities.each do |activity|
    active_user = activity.active_user
    cache activity, expires_in: 1.minute do
        json.id activity.id
        json.created_at activity.created_at
        json.phrase activity.activity_phrase
        json.type activity.activity_type
        if activity.activity_type == "Roll" and roll = Roll.where(id: activity.content_id).first
            json.roll do
                json.id roll.id
                json.created_at roll.created_at
                json.updated_at roll.updated_at
                json.caption roll.caption
                json.like_count roll.likes_count
                json.share_count roll.share_count
                json.comment_count roll.comments_count
                json.view_count roll.view_count
                json.viewed roll.viewed?(@current_user)
                json.liked roll.liked?(@current_user)
                json.bookmarked roll.bookmarked?(@current_user)
                json.bookmark_count roll.bookmark_count
                json.media_url roll.media_url
                json.thumbnail_url roll.thumbnail_url
                json.metadata do
                    json.width roll.width.to_f
                    json.height roll.height.to_f
                    json.duration roll.duration.to_f
                end
                json.user do
                    user = roll.user
                    json.id user.id
                    json.username user.username
                    json.user user.name
                    json.avatar user.avatar_url
                    json.verified user.verified 
                end
            end
        elsif activity.activity_type == "Post" and post = Post.where(id: activity.content_id).first
            json.post do
                json.id post.id
                json.created_at post.created_at
                json.updated_at post.updated_at
                json.caption post.caption
                json.like_count post.likes_count
                json.share_count post.share_count
                json.comment_count post.comments_count
                json.view_count post.view_count
                json.viewed post.viewed?(@current_user)
                json.liked post.liked?(@current_user)
                json.bookmarked post.bookmarked?(@current_user)
                json.bookmark_count post.bookmark_count
                json.media_url post.media_url
                json.thumbnail_url post.thumbnail_url
                json.metadata do
                    json.width post.width.to_f
                    json.height post.height.to_f
                    json.duration post.duration.to_f
                end
                json.user do
                    user = post.user
                    json.id user.id
                    json.username user.username
                    json.name user.name
                    json.avatar user.avatar_url
                    json.verified user.verified
                end               
            end
        elsif activity.activity_type == "MutualRelationshipRequest"
            action_items = [{title: "Accept", url: "#{@request.protocol}#{@request.raw_host_with_port}/v1/mutual_relationship_requests/accept", type: "button", style: "default"}, {title: "Deny", url: "#{@request.protocol}#{@request.raw_host_with_port}/v1/mutual_relationship_requests/deny", type: "button", style: "destructive"}]
            json.action_items action_items
        elsif activity.activity_type == "Comment" and comment = Comment.where(id: activity.content_id).first
            if post = comment.post                
                json.post do
                    json.id post.id
                    json.created_at post.created_at
                    json.updated_at post.updated_at
                    json.caption post.caption
                    json.like_count post.likes_count
                    json.share_count post.share_count
                    json.comment_count post.comments_count
                    json.view_count post.view_count
                    json.viewed post.viewed?(@current_user)
                    json.liked post.liked?(@current_user)
                    json.bookmarked post.bookmarked?(@current_user)
                    json.bookmark_count post.bookmark_count
                    json.media_url post.media_url
                    json.thumbnail_url post.thumbnail_url
                    json.metadata do
                        json.width post.width.to_f
                        json.height post.height.to_f
                        json.duration post.duration.to_f
                    end
                    json.user do
                        user = post.fetch_user
                        json.id user.id
                        json.username user.username
                        json.name user.name
                        json.avatar user.avatar_url
                        json.verified user.verified
                    end
                end
            elsif roll = comment.roll
                json.roll do
                    json.id roll.id
                    json.created_at roll.created_at
                    json.updated_at roll.updated_at
                    json.caption roll.caption
                    json.like_count roll.likes_count
                    json.share_count roll.share_count
                    json.comment_count roll.comments_count
                    json.view_count roll.view_count
                    json.viewed roll.viewed?(@current_user)
                    json.liked roll.liked?(@current_user)
                    json.bookmarked roll.bookmarked?(@current_user)
                    json.bookmark_count roll.bookmark_count
                    json.media_url roll.media_url
                    json.thumbnail_url roll.thumbnail_url
                    json.metadata do
                        json.width roll.width.to_f
                        json.height roll.height.to_f
                        json.duration roll.duration.to_f
                    end
                    json.user do
                        user = roll.fetch_user
                        json.id user.id
                        json.username user.username
                        json.name user.name
                        json.avatar user.avatar_url
                        json.verified user.verified
                    end
                end
            end
            json.comment do
                json.id comment.id
                json.body comment.body
                json.created_at comment.created_at
                json.updated_at comment.updated_at
                json.original_comment_id comment.original_comment_id
                json.like_count comment.likes_count
                json.reply_count comment.replies_count
                json.liked comment.liked?(@current_user)
                json.user do
                    json.id comment.user.id
                    json.name comment.user.name
                    json.username comment.user.username
                    json.verified comment.user.verified
                end
            end
        end
        json.active_user do 
            json.id active_user.id            
            json.username active_user.username
            json.name active_user.name
            json.avatar active_user.avatar_url
            json.verified active_user.verified
        end
    end
end
