@replies = @comment.replies 
json.array! @replies.each do |comment|
    cache comment, expires_in: 1.minute do
        @user = User.select(:username, :is_verified, :profile_picture_url).find(comment.user_id)
        json.comment do
            json.id comment.id
            json.body comment.body
            json.user_id comment.user_id
            json.post_id comment.post_id
            json.created_at comment.created_at
            json.updated_at comment.updated_at
            json.original_comment_id comment.original_comment_id
            json.replies_count comment.replies_count
        end
        json.user do 
            json.profile_picture_url @user.profile_picture_url
            json.username @user.username
            json.is_verified @user.is_verified
        end
    end
end
