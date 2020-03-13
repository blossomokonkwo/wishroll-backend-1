json.array! @chat_rooms.each do |chat_room|
    json.id chat_room.id
    json.name chat_room.name 
    json.created_at chat_room.created_at
    json.num_users chat_room.num_users
    json.recent_message chat_room.recent_message
end
