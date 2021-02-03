json.array! @blocked_users.each do |user|
    json.username user.username
    json.name user.name
    json.verified user.verified
    json.avatar user.avatar_url
end