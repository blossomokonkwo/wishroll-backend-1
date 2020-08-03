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
        phrase = "#{active_user.username} liked your reply 💕"
      else
        phrase = "#{active_user.username} liked your comment 💕"
      end
    when "Post"
      phrase = "#{active_user.username} liked your post 💕"
      media_url = content.thumbnail_url || content.media_url
    when "Roll"
      phrase = "#{active_user.username} liked your roll 💕" 
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
        delta_time = ((Time.zone.now - likeable.created_at.to_time) / 1.hour.seconds)
        if delta_time >= 48
          delta_time *= 4
        elsif delta_time >= 36
          delta_time *= 3.75
        elsif delta_time >= 32
          delta_time *= 3.5
        elsif delta_time >= 28
          delta_time *= 3.25
        elsif delta_time >= 24
          delta_time *= 3.15
        elsif delta_time >= 20
          delta_time *= 3
        elsif delta_time >= 19
          delta_time *= 2.9
        elsif delta_time >= 18
          delta_time *= 2.8
        elsif delta_time >= 17
          delta_time *= 2.7
        elsif delta_time >= 16
          delta_time *= 2.6
        elsif delta_time >= 15
          delta_time *= 2.5
        elsif delta_time >= 14
          delta_time *= 2.4
        elsif delta_time >= 13
          delta_time *= 2.3
        elsif delta_time >= 12
          delta_time *= 2.2
        elsif delta_time >= 11
          delta_time *= 2.1
        elsif delta_time >= 10
          delta_time *= 2.0
        elsif delta_time >= 9
          delta_time *= 1.9
        elsif delta_time >= 8
          delta_time *= 1.8
        elsif delta_time >= 7
          delta_time *= 1.7
        elsif delta_time >= 6
          delta_time *= 1.6
        elsif delta_time >= 5
          delta_time *= 1.5
        elsif delta_time >= 4
          delta_time *= 1.4
        elsif delta_time >= 3
          delta_time *= 1.3
        elsif delta_time >= 2
          delta_time *= 1.2
        elsif delta_time >= 1.5
          delta_time *= 1.15
        elsif delta_time >= 1
          delta_time *= 1.1
        else 
          delta_time *= 1
        end
        Post.find(likeable.id).update!(popularity_rank: (likeable.view_count + likeable.likes_count + likeable.share_count + likeable.bookmark_count) / delta_time)
      rescue => exception
        puts exception
      end
      
    end
  end

  #cache API's 
  include IdentityCache
  cache_belongs_to :user

end