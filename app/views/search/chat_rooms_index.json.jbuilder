json.array! @chat_rooms.each do |chat_room|
    json.name chat_room.name
end
