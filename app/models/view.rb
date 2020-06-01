class View < ApplicationRecord
  #Associations
  belongs_to :user
  belongs_to :viewable, polymorphic: true, counter_cache: :view_count, touch: true
  has_one :location, as: :locateable, dependent: :destroy

  #Validations
  validates :viewable_id, presence: {message: "The id of the viewable object must be included upon creation of a view object"}
  validates :viewable_type, presence: {message: "The type of the viewable content must be present upon creation of a view object"}
  validates :duration, presence: {message: "A view object must contain the duration that a user has spent viewing the content in seconds"}
end