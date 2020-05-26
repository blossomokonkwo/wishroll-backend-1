json.array! @comments.each do |comment|
    user = comment.user
    json.id comment.id
    json.body comment.body
    json.created_at comment.created_at
    json.updated_at comment.updated_at
    json.likes comment.likes_count
    json.replies comment.replies_count
    json.liked comment.liked?(@id)
    json.original_comment_id comment.original_comment_id
    json.user do
        json.id user.id
        json.username user.username
        json.avatar user.avatar_url
        json.verified user.verified
    end
end


