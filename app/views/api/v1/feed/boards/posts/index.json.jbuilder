json.array! @posts.each do |post| 
    user = post.user
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

    json.metadata do
        json.width post.width.to_f
        json.height post.height.to_f
        json.duration post.duration.to_f
    end

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

    json.top_comments post.fetch_comments do |comment|
        json.id comment.id
        json.body comment.body
        json.created_at comment.created_at
        json.updated_at comment.updated_at
        json.like_count comment.likes_count
        json.reply_count comment.replies_count
        json.liked comment.liked?(@current_user)
        json.original_comment_id comment.original_comment_id
        user = comment.fetch_user
        json.user do
            json.id user.id
            json.username user.username
            json.avatar user.avatar_url
            json.verified user.verified
        end
    end

    json.tags post.fetch_tags do |tag|
        json.id tag.id
        json.uuid tag.uuid
        json.text tag.text
        json.created_at tag.created_at
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
