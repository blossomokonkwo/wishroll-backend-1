json.array! @trending_tags.each do |tag|
    json.id tag.id
    json.text tag.title
    json.description tag.description
    json.posts tag.posts(limit: 6, offset: 0).each do |post|
        json.id post.id
        json.created_at post.created_at
        json.updated_at post.updated_at
        json.comment_count post.comments_count
        json.viewed post.viewed?(@current_user) if @current_user
        json.view_count post.view_count 
        json.bookmarked post.bookmarked?(@current_user) if @current_user
        json.bookmark_count post.bookmark_count
        json.liked post.liked?(@current_user) if @current_user
        json.like_count post.likes_count
        json.share_count post.share_count
        json.caption post.caption
        json.media_url post.media_url
        json.thumbnail_url post.thumbnail_url
        json.metadata do
            json.width post.width.to_f
            json.height post.height.to_f
            json.duration post.duration.to_f
        end

        user = User.fetch(post.user_id)
        json.user do
            json.id user.id
            json.username user.username
            json.avatar user.avatar_url
            json.verified user.verified
            json.following @current_user.following?(user) if @current_user and user != @current_user
        end
    end
end