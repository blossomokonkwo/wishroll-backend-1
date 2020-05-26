#sort method sorts the array by later post date.
@posts.sort! do |a,b|
  b.created_at <=> a.created_at
end
json.array! @posts.each do |post|
    cache post, expires_in: 3.hours do
        user = post.user
        json.user do 
            json.username user.username
            json.profile_picture_url user.avatar_url
            json.is_verified user.verified
        end
        json.post do
            json.id post.id
            json.original_post_id nil
            json.created_at post.created_at
            json.view_count post.view_count
            json.likes_count post.likes_count
            json.comments_count post.comments_count
            json.caption post.caption
            json.media_url post.media_url
            json.liked false
            post.likes.each do |like|
                cache like, expires_in: 5.minutes do
                    if like.user_id == user.id
                        json.liked true
                    end
                end
            end
        end
    end
end
