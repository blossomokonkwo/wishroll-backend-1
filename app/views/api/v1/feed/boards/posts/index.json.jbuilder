json.array! @posts.each do |post| 
    user = post.fetch_user
    json.id post.id
    json.created_at post.created_at
    json.updated_at post.updated_at
    json.comment_count post.comments_count
    json.viewed post.viewed?(@current_user)
    json.view_count post.view_count
    json.bookmarked post.bookmarked?(@current_user)
    json.bookmark_count post.bookmark_count
    json.share_count post.share_count
    json.liked post.liked?(@current_user)
    json.like_count post.likes_count
    json.caption post.caption
    json.media_url post.media_url
    json.thumbnail_url post.thumbnail_url
    if board = post.board
        json.board do
            json.id board.id
            json.uuid board.uuid
            json.name board.name
            json.description board.description
            json.created_at board.created_at
            json.updated_at board.updated_at
            json.member_count board.board_member_count
            json.is_featured board.featured
            json.avatar_url board.avatar_url
            json.banner_url board.banner_url
            json.is_member board.member?(user)
            json.is_admin board.admin?(user)
        end
    end
    json.metadata do
        json.width post.width.to_f
        json.height post.height.to_f
        json.duration post.duration.to_f
    end     
    json.user do 
        json.id user.id
        json.username user.username
        json.name user.name
        json.verified user.verified
        json.avatar user.avatar_url
        json.following @current_user.following?(user) if user != @current_user
    end
end
