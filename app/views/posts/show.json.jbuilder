json.post do 
    json.id @post.id
    json.user_id @post.user_id
    json.view_count @post.view_count
    json.caption @post.caption
    json.created_at @post.created_at
    json.image_url url_for @post.post_image
    json.original_post_id @post.original_post_id
end
json.tags do
    if @post.tags.count > 0
        @post.tags.each do |tag|
            json.id tag.id
            json.text tag.text
        end
    end        
end