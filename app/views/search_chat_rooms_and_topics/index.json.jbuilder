json.chat_rooms @chat_rooms.each do |chat_room|
    cache chat_room, expires_in: 2.minutes do
        json.chat_room do
            json.id chat_room.id
            json.updated_at chat_room.updated_at
            json.name chat_room.name
            json.num_users chat_room.num_users
        end
    end
    
end
json.topics @topics.each do |topic|
    cache topic, expires_in: 2.minutes do
        json.topic do
            json.id topic.id
            json.hot_topic topic.hot_topic
            json.title topic.title
            json.media_url topic.media_url
            json.created_at topic.created_at
        end
    end
end
