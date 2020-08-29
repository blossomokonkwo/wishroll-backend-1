class Share < ApplicationRecord
  #associations
  belongs_to :user
  belongs_to :shareable, polymorphic: true, counter_cache: :share_count, touch: true
  has_one :location, as: :locateable, dependent: :destroy
  enum shared_service: [:library, :facebook, :email, :instagram, :imessage, :messenger, :pinterest, :snapchat, :tiktok, :twitter, :whatsapp, :keyboard]
  after_create do
    shareable.touch
     #invalidate the cache for the shareable assocication
  end

end
