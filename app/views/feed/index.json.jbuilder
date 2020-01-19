#sort method sorts the array by later post date.
@posts.sort! do |a,b|
  b.created_at <=> a.created_at
end
json.array! @posts.each do |post|
    json.user do 
        user = User.find(post.user_id)
        json.username user.username
        if user.profile_picture.attached?
            json.profile_picture_url url_for(user.profile_picture)
        else
            json.profile_picture_url nil
        end
        json.is_verified user.is_verified
    end
    json.post do
        json.id post.id
        json.original_post_id post.original_post_id
        json.created_at post.created_at
        json.view_count post.view_count
        json.comments_count post.number_of_comments
        json.caption post.caption
        if post.post_image.attached?
            json.image_url url_for post.post_image
        else
            json.image_url nil
        end
    end
end
