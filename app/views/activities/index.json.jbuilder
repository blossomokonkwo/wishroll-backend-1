json.array! @activities.each do |activity|
    user = activity.active_user
    cache activity, expires_in: 1.hour do
        json.activity do
            json.happened_at activity.created_at
            json.activity_phrase activity.activity_phrase
            json.activity_thumbnail_image activity.media_url
            if activity.activity_type == "Comment"
                comment = Comment.find(activity.content_id)
                json.body comment.body
            end
        end
        json.user do 
            json.username user.username
            json.profile_picture_url user.avatar_url
            json.is_verified user.verified
        end
    end
end
