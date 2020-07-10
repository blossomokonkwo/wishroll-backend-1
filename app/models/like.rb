class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count, touch: true
  belongs_to :user, class_name: "User"
  has_one :location, as: :locateable, dependent: :destroy

  after_destroy do
  end

  after_create :update_likeable
  
  def update_likeable
    active_user = user
    content = likeable
    user = likeable.user
    activity_type = content.class.name
    phrase = ""
    media_url = ""
    case activity_type
    when "Comment"
      if content.original_comment_id
        phrase = "#{active_user.username} liked your reply"
      else
        phrase = "#{active_user.username} liked your comment"
      end
    when "Post"
      phrase = "#{active_user.username} liked your post"
      media_url = content.media_url
    when "Roll"
      phrase = "#{active_user.username} liked your roll" 
      media_url = content.thumbnail_url   
    end
    unless Activity.find_by(content_id: content.id, user_id: user.id, active_user_id: active_user.id, activity_type: activity_type) or active_user.id == user.id
      activity = Activity.new(content_id: content.id, user_id: user.id, active_user_id: active_user.id, activity_type: activity_type, media_url: media_url, activity_phrase: phrase)
      unless activity.save
        logger.debug {"Unable to create activity.\nAn error occured"}
      end 
    end
    if likeable_type == "Post" or likeable_type == "Roll"
      likeable.update!(popularity_rank: (likeable.view_count + likeable.likes_count + likeable.share_count + likeable.bookmark_count) / ((Time.zone.now - likeable.created_at.to_time) / 1.hour.seconds))
    end
  end

end