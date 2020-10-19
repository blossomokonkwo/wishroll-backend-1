json.array! @rolls.each do |roll|
    json.id roll.id
    json.created_at roll.created_at
    json.updated_at roll.updated_at
    json.viewed roll.viewed?(@current_user)
    json.view_count roll.view_count
    json.comment_count roll.comments_count
    json.liked roll.liked?(@current_user)
    json.like_count roll.likes_count
    json.bookmarked roll.bookmarked?(@current_user)
    json.bookmark_count roll.bookmark_count
    json.share_count roll.share_count
    json.caption roll.caption           
    json.media_url roll.media_url
    json.thumbnail_url roll.thumbnail_url
    user = User.fetch(roll.user_id)
    json.creator do 
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
        json.following @current_user.following?(user)
    end
end