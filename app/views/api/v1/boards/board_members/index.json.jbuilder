json.array! @board_members.each do |member|
    json.id member.user.id
    json.name member.user.name
    json.username member.user.username
    json.verified member.user.verified
    json.avatar member.user.avatar_url
    json.joined member.created_at
    json.is_admin member.is_admin
end
