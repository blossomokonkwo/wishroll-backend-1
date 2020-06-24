json.array! @rolls.each do |roll|
    user = roll.user
    json.id roll.id
    json.created_at roll.created_at
    json.updated_at roll.updated_at
    json.views roll.view_count
    json.shares roll.share_count
    json.viewed roll.viewed?(@id)
    json.comments_count roll.comments_count
    json.likes roll.likes_count
    json.liked roll.liked?(@id)
    json.bookmarked roll.bookmarked?(@id)
    json.bookmark_count roll.bookmark_count
    json.caption roll.caption           
    json.media_url roll.media_url
    json.thumbnail_url roll.thumbnail_url
    json.reactions_count roll.reactions_count
    json.creator do 
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
    end
end