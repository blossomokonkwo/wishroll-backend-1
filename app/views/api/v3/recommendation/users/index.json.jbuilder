json.array! @users.each do |user|
    json.id user.id
    json.name user.name
    json.username user.username
    json.verified user.verified
    json.avatar user.avatar_url
end