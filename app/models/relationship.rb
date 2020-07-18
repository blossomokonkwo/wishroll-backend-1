class Relationship < ApplicationRecord
  include IdentityCache
  belongs_to :followed_user, class_name: "User", foreign_key: :followed_id, counter_cache: :followers_count, touch: true
  belongs_to :follower_user, class_name: "User", foreign_key: :follower_id, counter_cache: :following_count, touch: true
  cache_belongs_to :followed_user
  cache_belongs_to :follower_user

  after_destroy do
    #we want to flush the cache for the boolean value that determines whether a user is following another user 
    logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:Relationship:Follower#{follower_user.id}:Following#{followed_user.id}"} if Rails.cache.delete("WishRoll:Cache:Relationship:Follower#{follower_user.id}:Following#{followed_user.id}")
    followed_user.touch; followed_user.touch
  end
  after_create do
    #after a relationship is created, we want to write a boolean value of true to cache which indicates that the following user is indeed following the followed user
    logger.debug {"[WishRoll Cache] write succeeded for WishRoll:Cache:Relationship:Follower#{followed_user.id}:Following#{followed_user.id}"} if Rails.cache.write("WishRoll:Cache:Relationship:Follower#{follower_user.id}:Following#{followed_user.id}", true)
    followed_user.touch; followed_user.touch
    unless Activity.find_by(content_id: id, active_user_id: follower_id, user_id: followed_id, activity_type: self.class.name)
      Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "#{follower_user.username} began following you")
    end
  end
end
