json.array! @topics.each do |topic|
    json.id topic.id
    json.title topic.title
    json.media_url topic.topic_image.attached? ? polymorphic_url(topic.topic_image) : nil
    json.created_at topic.created_at
    json.hot_topic topic.hot_topic
end
