json.array! @posts.each do |post|
    user = post.fetch_user
    json.id post.id
    json.created_at post.created_at
    json.updated_at post.updated_at
    json.comment_count post.comments_count
    json.viewed post.viewed?(@current_user)
    json.view_count post.view_count
    json.bookmarked post.bookmarked?(@current_user)
    json.bookmark_count post.bookmark_count
    json.share_count post.share_count
    json.liked post.liked?(@current_user)
    json.like_count post.likes_count
    json.caption post.caption
    json.media_url post.media_url
    json.thumbnail_url post.thumbnail_url

    json.metadata do
        json.width post.width.to_f
        json.height post.height.to_f
        json.duration post.duration.to_f
    end     

    json.top_comments post.fetch_comments do |comment|
        json.id comment.id
        json.body comment.body
        json.created_at comment.created_at
        json.updated_at comment.updated_at
        json.like_count comment.likes_count
        json.reply_count comment.replies_count
        json.liked comment.liked?(@current_user)
        json.original_comment_id comment.original_comment_id
        comment_user = comment.fetch_user
        json.user do
            json.id comment_user.id
            json.username comment_user.username
            json.avatar comment_user.avatar_url
            json.verified comment_user.verified
        end
    end

    json.tags post.fetch_tags do |tag|
        json.id tag.id
        json.uuid tag.uuid
        json.text tag.text
        json.created_at tag.created_at
    end

    json.user do 
        json.id user.id
        json.username user.username
        json.name user.name
        json.verified user.verified
        json.avatar user.avatar_url
        json.following @current_user.following?(user) if user != @current_user
    end
end