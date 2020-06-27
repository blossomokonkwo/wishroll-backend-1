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
    #update the viewable object's popularity rank by taking its view count and dividing it by the difference in hours from the current time to when the object was created
    viewable.update!(popularity_rank: (viewable.view_count + viewable.likes_count + viewable.share_count + viewable.bookmark_count) / ((Time.zone.now - viewable.created_at.to_time) / 1.hour.seconds))
  end
end