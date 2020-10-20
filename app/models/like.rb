class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count, touch: true
  belongs_to :user, -> { select([:username, :id, :name, :verified, :avatar_url, :total_num_likes])}, counter_cache: :total_num_likes

  after_destroy do
    #we want to update the likeable's updated at date when a like is being destroyed. This invalidates the cache for the likeable and forces a DB read.
    logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{likeable.uuid}"} if Rails.cache.delete("WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{likeable.uuid}")
    likeable.touch
    if creator = likeable.user
      if likeable.instance_of? Post
        creator.post_likes_count -= 1
        creator.save
      elsif likeable.instance_of? Roll
        creator.roll_likes_count -= 1
        creator.save
      end
    end
  end

  after_create :update_likeable

  def update_likeable
    logger.debug {"[WishRoll Cache] write succeeded for WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{likeable.uuid}"} if Rails.cache.write("WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{likeable.uuid}", true)
    #write the boolean value of true whenever a like is created 
    if creator = likeable.user
      if likeable.instance_of? Post
        creator.post_likes_count += 1
        creator.save
      elsif likeable.instance_of? Roll
        creator.roll_likes_count += 1
        creator.save
      end
    end
  end

end