class View < ApplicationRecord
  #Associations
  belongs_to :user, -> { select([:username, :id, :name, :verified, :avatar_url])}, optional: true
  belongs_to :viewable, polymorphic: true, counter_cache: :view_count, touch: true

  #Validations
  validates :viewable_id, presence: {message: "The id of the viewable object must be included upon creation of a view object"}
  validates :viewable_type, presence: {message: "The type of the viewable content must be present upon creation of a view object"}
  validates :duration, presence: {message: "A view object must contain the duration that a user has spent viewing the content in seconds"}
  after_create do
    if user_id
      logger.debug {"[WishRoll Cache] write succeeded for WishRoll:Cache:View:Viewer:#{user_id}:Viewed:#{viewable.uuid}"} if Rails.cache.write("WishRoll:Cache:View:Viewer:#{user_id}:Viewed:#{viewable.uuid}", true)#write the boolean value of true to the cache
    end
  end

  after_destroy do
    if user_id
      logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:View:Viewer:#{user_id}:Viewed:#{viewable.uuid}"} if Rails.cache.delete("WishRoll:Cache:View:Viewer:#{user_id}:Viewed:#{viewable.uuid}")
    end
  end
end