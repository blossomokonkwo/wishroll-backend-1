class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count, touch: true
  belongs_to :user, class_name: "User"
  has_one :location, as: :locateable, dependent: :destroy

  after_destroy do
  end

  after_create :create_activity
  
  def create_activity
    active_user = user
    content = likeable
    user = likeable.user
    activity_type = content.class.name
    phrase = ""
    media_url = ""
    case activity_type
    when "Comment"
      phrase = "#{active_user.username} liked your comment"
    when "Post"
      phrase = "#{active_user.username} liked your post"
      media_url = content.media_url
    when "Roll"
      phrase = "#{active_user.username} liked your reaction" 
      media_url = content.media_url   
    end
    unless Activity.find_by(content_id: content.id, user_id: user.id, active_user_id: active_user.id, activity_type: activity_type)
      activity = Activity.new(content_id: content.id, user_id: user.id, active_user_id: active_user.id, activity_type: activity_type, media_url: media_url, activity_phrase: phrase)
      unless activity.save
        logger.debug {"Unable to create activity.\nAn error occured"}
      end 
    end
  end

end