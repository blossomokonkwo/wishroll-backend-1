json.array! @activities.each do |activity|
  json.happened_at activity.created_at
  json.activity_phrase activity.activity_phrase
  if activity.activity_type == "Post" 
    post = Post.find(activity.content_id)
    json.activity_thumbnail_image url_for post.post_image
  elsif activity.activity_type == "Comment"
    comment = Comment.find(activity.content_id)
    json.body comment.body
  end
end
