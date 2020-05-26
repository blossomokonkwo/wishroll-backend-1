json.array! @posts.each do |post|
    user = post.cached_user
    cache post, expires_in: 5.minutes do
        json.id post.id
        json.created_at post.created_at
        json.updated_at post.updated_at
        json.views post.view_count
        json.comments_count post.comments_count
        json.likes post.likes_count
        json.liked post.liked?(@id)
        json.caption post.caption           
        json.media_url post.media_url
        json.thumbnail_url post.thumbnail_url
        json.user do 
            json.id user.id
            json.username user.username
            json.verified user.verified
            json.avatar user.avatar_url
        end
        json.tags post.tags.each do |t|
            json.id t.id
            json.text t.text
        end
    end
end