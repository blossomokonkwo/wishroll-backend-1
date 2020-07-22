class View < ApplicationRecord
  #Associations
  belongs_to :user
  belongs_to :viewable, polymorphic: true, counter_cache: :view_count, touch: true
  has_one :location, as: :locateable, dependent: :destroy

  #Validations
  validates :viewable_id, presence: {message: "The id of the viewable object must be included upon creation of a view object"}
  validates :viewable_type, presence: {message: "The type of the viewable content must be present upon creation of a view object"}
  validates :duration, presence: {message: "A view object must contain the duration that a user has spent viewing the content in seconds"}
  after_create do
    Rails.cache.write("WishRoll:Cache:View:Viewer:#{user.id}:Viewed:#{viewable.uuid}", true)#write the boolean value of true to the cache
    viewable.user.touch #we want to invalidate the cache for the the user whos content was viewed so that their view count can be accurate 
    #update the viewable object's popularity rank by taking its view count and dividing it by the difference in hours from the current time to when the object was created
    delta_time = ((Time.zone.now - viewable.created_at.to_time) / 1.hour.seconds)
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
    viewable.update!(popularity_rank: (viewable.view_count + viewable.likes_count + viewable.share_count + viewable.bookmark_count) / delta_time)
  end

  #cache API's
  include IdentityCache
  cache_belongs_to :user
  cache_belongs_to :viewable
  cache_index :viewable, :user
end