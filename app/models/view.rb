class View < ApplicationRecord
  #Associations
  belongs_to :user, -> { select([:username, :id, :name, :verified, :avatar_url, :total_num_views])}, counter_cache: :total_num_views
  belongs_to :viewable, polymorphic: true, counter_cache: :view_count, touch: true

  #Validations
  validates :viewable_id, presence: {message: "The id of the viewable object must be included upon creation of a view object"}
  validates :viewable_type, presence: {message: "The type of the viewable content must be present upon creation of a view object"}
  validates :duration, presence: {message: "A view object must contain the duration that a user has spent viewing the content in seconds"}
  after_create do
    logger.debug {"[WishRoll Cache] write succeeded for WishRoll:Cache:View:Viewer:#{user.id}:Viewed:#{viewable.uuid}"} if Rails.cache.write("WishRoll:Cache:View:Viewer:#{user.id}:Viewed:#{viewable.uuid}", true)#write the boolean value of true to the cache
    if creator = viewable.user        
      if viewable.instance_of? Post 
        creator.post_views_count += 1
      elsif viewable.instance_of? Roll
        creator.roll_views_count += 1
      end
      creator.save
    end
  end

  after_destroy do
    logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:View:Viewer:#{user.id}:Viewed:#{viewable.uuid}"} if Rails.cache.delete("WishRoll:Cache:View:Viewer:#{user.id}:Viewed:#{viewable.uuid}")
    if creator = viewable.user
      if viewable.instance_of? Post
        creator.post_views_count -= 1
      elsif viewable.instance_of? Roll
        creator.roll_views_count -= 1
      end
      creator.save
    end
  end
end