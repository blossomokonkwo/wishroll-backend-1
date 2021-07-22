json.id @user.id
json.created_at @user.created_at
json.updated_at @user.updated_at
json.username @user.username
json.name @user.name
json.verified @user.verified
json.bio @user.bio
json.num_followers @user.followers_count
json.num_following @user.following_count
json.avatar @user.avatar_url
json.profile_background_url @user.profile_background_url
json.posts_count @user.posts_count
json.following @user.following?(@current_user)
json.mutual_status @user.mutual_status_with?(@current_user) if @current_user != @user
json.mutual_relationships_count @user.mutual_relationships_count