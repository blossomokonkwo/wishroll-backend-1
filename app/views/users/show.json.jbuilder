#this response is sent when a users profile page data is requested. This response includes conditional checks that check whether or not the current_user is requesting his or her own profile data.
#Response includes: The profile data of the user including their username, first and last name, bio, and profile picture url. An array of all a users posts are also returned.
cache @user, expires_in: 1.hour do
    json.user do 
        json.username @user.username
        json.first_name @user.first_name
        json.last_name @user.last_name
        json.is_verified @user.is_verified
        json.bio @user.bio
        json.followers_count @user.follower_users.count
        json.following_count @user.followed_users.count
        is_following = nil
        #check first if the requested user is the current_user. If so, then the 'is_following' field isn't nil but must be true or false.
        #Loop through all of a users followers and check if the current_user is among the follower users.
        if @current_user != @user
            #if the current_user is not the user whose data is being requested, we can check whether or not the user is following the user whose account data is being requested.
            is_following = false
            @user.follower_users.each do |follower|
                if follower == @current_user
                    is_following = true
                end
            end
        end
        json.is_following is_following
        #frontend check: The frontend should check whether or not the is_following field is null, true, or false. If the field is null, then the current_user is requesting his or her own profile data.
        #if the field is false, then the current_user does not currently follow the user. If it's true, then the current_user is currently following the requested user.
    end
end

json.posts @user.posts.each do |post|
    json.id post.id
    json.user_id post.user_id
    json.original_post_id post.original_post_id
    json.created_at post.created_at
    json.view_count post.view_count
    json.comments_count post.comments.size
    json.caption post.caption
    json.image_url nil
    if post.post_image.attached?
        json.image_url url_for post.post_image 
    end
end if @user.posts #only run the .each block if the user has any posts or a null error will be raised!
