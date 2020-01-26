json.user do 
    json.username @user.username
    json.is_verified @user.is_verified
    json.profile_picture_url @user.profile_picture_url
end
json.post do 
    json.id @post.id
    json.view_count @post.view_count
    json.comments_count @post.comments_count
    json.likes_count @post.likes_count
    json.caption @post.caption
    json.created_at @post.created_at
    json.media_url @post.posts_media_url
    json.original_post_id @post.original_post_id
end
json.tags do
    @post.tags.each do |tag|
        json.id tag.id
        json.text tag.text
    end        
end