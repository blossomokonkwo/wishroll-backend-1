json.array! @rolls.each do |roll|
    user = roll.user
    json.id roll.id
    json.created_at roll.created_at
    json.updated_at roll.updated_at
    json.view_count roll.view_count  
    json.viewed roll.viewed?(@current_user.id)  
    json.share_count roll.share_count        
    json.bookmark_count roll.bookmark_count
    json.bookmarked roll.bookmarked?(@current_user) if @current_user
    json.comment_count roll.comments_count
    json.like_count roll.likes_count
    json.liked roll.liked?(@current_user) if @current_user 
    json.caption roll.caption           
    json.media_url roll.media_url
    json.thumbnail_url roll.thumbnail_url
    json.metadata do
        json.width roll.width.to_f
        json.height roll.height.to_f
        json.duration roll.duration.to_f
    end
    json.user do 
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
        json.following @current_user.following?(user) if @current_user and @current_user != user
    end
end