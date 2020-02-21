json.array! @comments.each do |comment|
    cache comment, expires_in: 2.minutes do
        @user = User.select(:username, :is_verified).find(comment.user_id)
        json.comment do 
            json.id comment.id
            json.body comment.body
            json.user_id comment.user_id
            json.post_id comment.post_id
            json.created_at comment.created_at
            json.updated_at comment.updated_at
            json.original_comment_id comment.original_comment_id
            json.replies_count comment.replies_count
            json.likes_count comment.likes_count
            if comment.likes.find_by(user_id: @current_user_id).present?
                json.liked true
            else
                json.liked false
            end
        end
        json.user do
            json.profile_picture_url url_for(@user.profile_picture) if @user.profile_picture.attached?
            json.username @user.username
            json.is_verified @user.is_verified
        end
    end
end