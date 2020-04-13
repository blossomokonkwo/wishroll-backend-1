json.array! @posts.each do |post|
    json.id post.id
    json.media_url post.posts_media_url
end