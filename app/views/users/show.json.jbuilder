#this response is sent when a users profile page data is requested. This response includes conditional checks that check whether or not the current_user is requesting his or her own profile data.
#Response includes: The profile data of the user including their username, first and last name, bio, and profile picture url. An array of all a users posts are also returned.
cache @user, expires_in: 1.hour do
    json.user do 
        json.username @user.username
        json.full_name @user.full_name
        json.is_verified @user.is_verified
        json.bio @user.bio
        json.followers_count @user.followers_count
        json.following_count @user.following_count
        json.total_view_count @user.total_view_count
        json.profile_picture_url @user.profile_picture_url
        is_following = nil
        #check first if the requested user is the current_user. If so, then the 'is_following' field isn't nil but must be true or false.
        #Loop through all of a users followers and check if the current_user is among the follower users.
        if @current_user != @user
            #if the current_user is not the user whose data is being requested, we can check whether or not the user is following the user whose account data is being requested.
            is_following = @user.follower_users.include?(@current_user) ? true : false
        end
        json.is_following is_following
        #frontend check: The frontend should check whether or not the is_following field is null, true, or false. If the field is null, then the current_user is requesting his or her own profile data.
        #if the field is false, then the current_user does not currently follow the user. If it's true, then the current_user is currently following the requested user.
    end
end

json.posts @user.posts.each do |post|
    cache post, expires_in: 1.hour do
        json.id post.id
        json.original_post_id post.original_post_id
        json.created_at post.created_at
        json.view_count post.view_count
        json.comments_count post.comments_count
        json.likes_count post.likes_count
        json.caption post.caption
        json.media_url post.posts_media_url
    end
end  #only run the .each block if the user has any posts or a null error will be raised!
json.liked_posts Like.select(:likeable_id).where(likeable_type: "Post", user_id: @user.id).limit(50).order(created_at: :desc).each do |like|
    cache like, expires_in: 1.hour do
        post = Post.find(like.likeable_id)
        cache post, expires_in: 1.hour do
            json.id post.id
            json.original_post_id post.original_post_id
            json.created_at post.created_at
            json.view_count post.view_count
            json.comments_count post.comments_count
            json.likes_count post.likes_count
            json.caption post.caption
            json.media_url post.posts_media_url
        end
    end
 end