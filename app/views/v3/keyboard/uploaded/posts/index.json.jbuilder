json.array! @posts.each do |post|
    json.id post.id
    json.media_url post.media_url
    json.thumbnail_url post.thumbnail_url
end