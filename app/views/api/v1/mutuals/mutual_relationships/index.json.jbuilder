json.array! @mutuals.each do |mutual|
    json.id mutual.id
    json.username mutual.username
    json.name mutual.name
    json.verified mutual.verified
    json.avatar mutual.avatar_url
end
