json.array! @topics.each do |topic|
    json.id topic.id
    json.title topic.title
    json.media_url topic.media_url
    json.created_at topic.created_at
    json.hot_topic topic.hot_topic
end
