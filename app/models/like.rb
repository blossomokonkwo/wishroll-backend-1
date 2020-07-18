class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count, touch: true
  belongs_to :user, class_name: "User"
  has_one :location, as: :locateable, dependent: :destroy

  after_destroy do
    #we want to update the likeable's updated at date when a like is being destroyed. This invalidates the cache for the likeable and forces a DB read.
    logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{likeable.uuid}"} if Rails.cache.delete("WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{likeable.uuid}")
    likeable.touch
  end

  after_create :update_likeable

  def update_likeable
    logger.debug {"[WishRoll Cache] write succeeded for WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{likeable.uuid}"} if Rails.cache.write("WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{likeable.uuid}", true)
    #write the boolean value of true whenever a like is created 
     #we want change the updated at date of the post model when it has been liked. This is because the after commit callback isn't called when the counter_cache counters are updated (the likes count)
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
      begin
        Post.find(likeable.id).update!(popularity_rank: (likeable.view_count + likeable.likes_count + likeable.share_count + likeable.bookmark_count) / ((Time.zone.now - likeable.created_at.to_time) / 1.hour.seconds))
      rescue => exception
        puts exception
      end
      
    end
  end

  #cache API's 
  include IdentityCache
  cache_belongs_to :user

end