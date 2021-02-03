json.array! @comments.each do |comment|
    json.id comment.id
    json.body comment.body
    json.created_at comment.created_at
    json.updated_at comment.updated_at
    json.like_count comment.likes_count
    json.reply_count comment.replies_count
    json.liked comment.liked?(@current_user)
    json.original_comment_id comment.original_comment_id
    user = comment.user
    json.user do
        json.id user.id
        json.username user.username
        json.avatar user.avatar_url
        json.verified user.verified
    end
end


