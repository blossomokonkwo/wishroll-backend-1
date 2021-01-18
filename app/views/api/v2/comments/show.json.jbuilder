json.array! @replies.each do |reply|
    user = reply.user
    json.id reply.id
    json.body reply.body
    json.created_at reply.created_at
    json.updated_at reply.updated_at
    json.like_count reply.likes
    json.reply_count reply.replies_count
    json.original_comment_id reply.original_comment_id
    json.user do 
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
    end
end