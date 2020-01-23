@replies = @comment.replies 
json.array! @replies.each do |comment|
    cache comment, expires_in: 1.minute do
        @user = User.find(comment.user_id)
        json.id comment.id
        json.body comment.body
        json.user_id comment.user_id
        json.post_id comment.post_id
        json.created_at comment.created_at
        json.updated_at comment.updated_at
        json.original_comment_id comment.original_comment_id
        json.replies_count comment.replies.size
        json.profile_image_url nil
        if @user.profile_picture.attached?
            json.profile_image_url url_for(@user.profile_picture)
        end
        json.username @user.username
        json.is_verified @user.is_verified
    end
end
