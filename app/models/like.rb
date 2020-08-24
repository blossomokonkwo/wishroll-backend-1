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
  end

  #cache API's 
  include IdentityCache
  cache_belongs_to :user

end