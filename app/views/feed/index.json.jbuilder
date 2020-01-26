#sort method sorts the array by later post date.
@posts.sort! do |a,b|
  b.created_at <=> a.created_at
end
json.array! @posts.each do |post|
    cache post, expires_in: 3.hours do
        json.user do 
            user = User.find(post.user_id)
            json.username user.username
            json.profile_picture_url user.profile_picture_url
            json.is_verified user.is_verified
        end
        json.post do
            json.id post.id
            json.original_post_id post.original_post_id
            json.created_at post.created_at
            json.view_count post.view_count
            json.comments_count post.comments_count
            json.caption post.caption
            json.media_url post.posts_media_url
        end
    end
end
