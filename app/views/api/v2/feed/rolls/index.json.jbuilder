json.array! @rolls.each do |roll|
    
    json.id roll.id
    json.created_at roll.created_at
    json.updated_at roll.updated_at
    json.caption roll.caption  
    json.viewed roll.viewed?(@current_user) if @current_user
    json.view_count roll.view_count
    json.comment_count roll.comments_count
    json.liked roll.liked?(@current_user) if @current_user
    json.like_count roll.likes_count
    json.bookmarked roll.bookmarked?(@current_user) if @current_user
    json.bookmark_count roll.bookmark_count
    json.share_count roll.share_count         
    json.media_url roll.media_url
    json.thumbnail_url roll.thumbnail_url
    json.metadata do
        json.width roll.width
        json.height roll.height
        json.duration roll.duration
    end

    user = User.fetch(roll.user_id)
    json.user do 
        json.id user.id
        json.username user.username
        json.name user.name
        json.verified user.verified
        json.avatar user.avatar_url
        json.following @current_user.following?(user) if @current_user and @current_user != user
    end
end