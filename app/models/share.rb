class Share < ApplicationRecord
  #associations
  belongs_to :user
  belongs_to :shareable, polymorphic: true, counter_cache: :share_count, touch: true
  has_one :location, as: :locateable, dependent: :destroy
  enum shared_service: [:library, :instagram, :snapchat, :tik_tok, :imessage, :twitter, :facebook, :tinder, :reddit, :messenger, :whatsapp, :email, :drop_box]

  after_create do
    shareable.touch
     #invalidate the cache for the shareable assocication
     delta_time = ((Time.zone.now - shareable.created_at.to_time) / 1.hour.seconds)
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
    shareable.update!(popularity_rank: (shareable.view_count + shareable.likes_count + shareable.share_count + shareable.bookmark_count) / delta_time)
  end

end
