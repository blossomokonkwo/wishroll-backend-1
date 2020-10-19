class Share < ApplicationRecord
  #associations
  belongs_to :user, counter_cache: :total_num_shares
  belongs_to :shareable, polymorphic: true, counter_cache: :share_count, touch: true
  has_one :location, as: :locateable, dependent: :destroy
  enum shared_service: [:library, :facebook, :email, :instagram, :imessage, :messenger, :pinterest, :snapchat, :tiktok, :twitter, :whatsapp, :keyboard, :other]
  after_create do
    shareable.touch
     #invalidate the cache for the shareable assocication
    if creator = shareable.user
      if shareable.instance_of? Post
        creator.post_shares_count += 1      
      elsif shareable.instance_of? Roll
        creator.roll_shares_count += 1
      end
      creator.save!
    end
  end

  after_destroy do
    shareable.touch
    if creator = shareable.user
      if shareable.instance_of? Post
        creator.post_shares_count -= 1      
      elsif shareable.instance_of? Roll
        creator.roll_shares_count -= 1
      end
      creator.save!
    end
  end

end
