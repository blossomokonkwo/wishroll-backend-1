json.topics @topics.each do |topic|
    cache :topic, expires_in: 1.hour do 
        json.title topic.title
        json.is_hot_topic topic.hot_topic
        json.media_url topic.media_url
        json.created_at topic.created_at
    end
end
json.hot_topics @hot_topics.each do |hot_topic|
    cache: :hot_topic, expires_in: 1.hour do
        json.title hot_topic.title
        json.is_hot_topic hot_topic.hot_topic
        json.media_url topic.media_url
        json.created_at topic.created_at
    end
end