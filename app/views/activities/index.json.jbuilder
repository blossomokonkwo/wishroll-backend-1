json.array! @activities.each do |activity|
    user = User.select(:username, :profile_picture_url, :is_verified).find(activity.active_user_id)
    cache activity, expires_in: 1.hour do
        json.activity do
            json.happened_at activity.created_at
            json.activity_phrase activity.activity_phrase
            json.activity_thumbnail_image activity.post_url
            if activity.activity_type == "Comment"
                comment = Comment.find(activity.content_id)
                json.body comment.body
            end
        end
        json.user do 
            json.username user.username
            json.profile_picture_url url_for(user.profile_picture) if user.profile_picture.attached?
            json.is_verified user.is_verified
        end
    end
end
