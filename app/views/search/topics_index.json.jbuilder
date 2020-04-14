json.array! @topics.each do |topic|
    json.title topic.title
    json.media_url topic.media_url
end
