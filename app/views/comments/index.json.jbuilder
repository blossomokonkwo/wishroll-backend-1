json.array! @comments.each do |comment|
    cache comment, expires_in: 5.minutes do
        @user = User.find(comment.user_id)
        json.id comment.id
        json.body comment.body
        json.user_id comment.user_id
        json.post_id comment.post_id
        json.created_at comment.created_at
        json.updated_at comment.updated_at
        json.original_comment_id comment.original_comment_id
        json.replies_count comment.replies.size
        json.likes_count comment.likes.size
        if @user.profile_picture.attached?
            json.profile_image_url url_for(@user.profile_picture) 
        else
            json.profile_image_url nil
        end
        json.username @user.username
        json.is_verified @user.is_verified
    end
end