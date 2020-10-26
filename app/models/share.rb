class Share < ApplicationRecord
  #associations
  belongs_to :user, optional: true
  belongs_to :shareable, polymorphic: true, counter_cache: :share_count, touch: true
  enum shared_service: [:library, :facebook, :email, :instagram, :imessage, :messenger, :pinterest, :snapchat, :tiktok, :twitter, :whatsapp, :keyboard, :other]
end
