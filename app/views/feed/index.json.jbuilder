#sort method sorts the array by later post date.
@posts.sort! do |a,b|
  b.created_at <=> a.created_at
end
json.array! @posts.each do |post|
    cache post, expires_in: 3.hours do
        user = User.find(post.user_id)
        json.user do 
            json.username user.username
            json.profile_picture_url url_for(@user.profile_picture) if @user.profile_picture.attached?
            json.is_verified user.is_verified
        end
        json.post do
            json.id post.id
            json.original_post_id post.original_post_id
            json.created_at post.created_at
            json.view_count post.view_count
            json.likes_count post.likes_count
            json.comments_count post.comments_count
            json.caption post.caption
            json.media_url post.posts_media_url
            if post.likes.find_by(user_id: user.id)
                json.liked true
            else
                json.liked false
            end
        end
    end
end
