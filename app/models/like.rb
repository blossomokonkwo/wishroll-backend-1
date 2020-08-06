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
        if likeable.likes_count < 100
          phrase = "#{active_user.username} liked your reply 💕"
        elsif likeable.likes_count == 101
          phrase = "over one hundred people liked your reply 💕"
        elsif likeable.likes_count == 201
          phrase = "over two hundred people liked your reply 💕"
        elsif likeable.likes_count == 301
          phrase = "over three hundred people liked your reply 💕"
        elsif likeable.likes_count == 401
          phrase = "over four hundred people liked your reply 💕"
        elsif likeable.likes_count == 501
          phrase = "over five hundred people liked your reply 💕"
        elsif likeable.likes_count == 601
          phrase = "over six hundred people liked your reply 💕"
        elsif likeable.likes_count == 701
          phrase = "over seven hundred people liked your reply 💕"
        elsif likeable.likes_count == 801
          phrase = "over eight hundred people liked your reply 💕"
        elsif likeable.likes_count == 901
          phrase = "over nine hundred people liked your reply 💕"
        elsif likeable.likes_count == 1001
          phrase = "over one thousand people liked your reply 💕"
        elsif likeable.likes_count == 2001
          phrase = "over two thousand people liked your reply 💕"
        elsif likeable.likes_count == 3001
          phrase = "over three thousand people liked your reply 💕"
        elsif likeable.likes_count == 4001
          phrase = "over four thousand people liked your reply 💕"
        elsif likeable.likes_count == 5001
          phrase = "over five thousand people liked your reply 💕"
        end
      else
        if likeable.likes_count < 100
          phrase = "#{active_user.username} liked your comment 💕"
        elsif likeable.likes_count == 101
          phrase = "over one hundred people liked your comment 💕"
        elsif likeable.likes_count == 201
          phrase = "over two hundred people liked your comment 💕"
        elsif likeable.likes_count == 301
          phrase = "over three hundred people liked your comment 💕"
        elsif likeable.likes_count == 401
          phrase = "over four hundred people liked your comment 💕"
        elsif likeable.likes_count == 501
          phrase = "over five hundred people liked your comment 💕"
        elsif likeable.likes_count == 601
          phrase = "over six hundred people liked your comment 💕"
        elsif likeable.likes_count == 701
          phrase = "over seven hundred people liked your comment 💕"
        elsif likeable.likes_count == 801
          phrase = "over eight hundred people liked your comment 💕"
        elsif likeable.likes_count == 901
          phrase = "over nine hundred people liked your comment 💕"
        elsif likeable.likes_count == 1001
          phrase = "over one thousand people liked your comment 💕"
        elsif likeable.likes_count == 2001
          phrase = "over two thousand people liked your comment 💕"
        elsif likeable.likes_count == 3001
          phrase = "over three thousand people liked your comment 💕"
        elsif likeable.likes_count == 4001
          phrase = "over four thousand people liked your comment 💕"
        elsif likeable.likes_count == 5001
          phrase = "over five thousand people liked your comment 💕"
        end
      end
    when "Post"
      if likeable.likes_count < 100
        phrase = "#{active_user.username} liked your post 💕"
      elsif likeable.likes_count == 101
        phrase = "over one hundred people liked your post 💕"
      elsif likeable.likes_count == 201
        phrase = "over two hundred people liked your post 💕"
      elsif likeable.likes_count == 301
        phrase = "over three hundred people liked your post 💕"
      elsif likeable.likes_count == 401
        phrase = "over four hundred people liked your post 💕"
      elsif likeable.likes_count == 501
        phrase = "over five hundred people liked your post 💕"
      elsif likeable.likes_count == 601
        phrase = "over six hundred people liked your post 💕"
      elsif likeable.likes_count == 701
        phrase = "over seven hundred people liked your post 💕"
      elsif likeable.likes_count == 801
        phrase = "over eight hundred people liked your post 💕"
      elsif likeable.likes_count == 901
        phrase = "over nine hundred people liked your post 💕"
      elsif likeable.likes_count == 1001
        phrase = "over one thousand people liked your post 💕"
      elsif likeable.likes_count == 2001
        phrase = "over two thousand people liked your post 💕"
      elsif likeable.likes_count == 3001
        phrase = "over three thousand people liked your post 💕"
      elsif likeable.likes_count == 4001
        phrase = "over four thousand people liked your post 💕"
      elsif likeable.likes_count == 5001
        phrase = "over five thousand people liked your post 💕"
      end
      media_url = content.thumbnail_url || content.media_url
    when "Roll"
      phrase = "#{active_user.username} liked your roll 💕" 
      media_url = content.thumbnail_url   
    end
    unless Activity.find_by(content_id: content.id, user_id: user.id, active_user_id: active_user.id, activity_type: activity_type) or active_user.id == user.id
      if likeable.likes_count < 100 or likeable.likes_count == 101 or likeable.likes_count == 201 or likeable.likes_count == 301 or likeable.likes_count == 401 or likeable.likes_count == 501 or likeable.likes_count == 601 or likeable.likes_count == 701 or likeable.likes_count == 801 or likeable.likes_count == 901 or likeable.likes_count == 1001 or likeable.likes_count == 2001 or likeable.likes_count == 3001 or likeable.likes_count == 4001 or likeable.likes_count == 5001
        activity = Activity.new(content_id: content.id, user_id: user.id, active_user_id: active_user.id, activity_type: activity_type, media_url: media_url, activity_phrase: phrase)
        unless activity.save
          logger.debug {"Unable to create activity.\nAn error occured"}
        end 
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