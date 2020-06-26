json.array! @rolls.each do |roll|
    user = roll.user
    json.id roll.id
    json.created_at roll.created_at
    json.updated_at roll.updated_at
    json.view_count roll.view_count
    json.share_count roll.share_count
    json.viewed roll.viewed?(@id)
    json.bookmarked post.bookmarked?(@id)
    json.bookmark_count roll.bookmark_count
    json.comment_count roll.comments_count
    json.like_count roll.likes_count
    json.liked roll.liked?(@id)
    json.caption roll.caption           
    json.media_url roll.media_url
    json.thumbnail_url roll.thumbnail_url
    json.reaction_count roll.reactions_count
    json.creator do 
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
    end
end