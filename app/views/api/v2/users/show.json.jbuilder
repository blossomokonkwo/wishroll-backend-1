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
json.social_media @user.social_media
json.mutuals @user.mutuals(limit: 5).each do |mutual|
    json.id mutual.id
    json.username mutual.username
    json.name mutual.name
    json.verified mutual.verified
    json.avatar mutual.avatar_url
    json.profile_background_url mutual.profile_background_url
    json.bio mutual.bio    
    json.created_at mutual.created_at
    json.updated_at mutual.updated_at
end
