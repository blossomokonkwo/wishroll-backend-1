class BlockRelationship < ApplicationRecord
    belongs_to :blocker_user, class_name: "User", foreign_key: :blocker_id
    belongs_to :blocked_user, class_name: "User", foreign_key: :blocked_id
    
    after_create do
        logger.debug {"[WishRoll Cache] write succeeded for WishRoll:Cache:BlockRelationship:Blocker#{blocker_id}:Blocked#{blocked_id}"} if Rails.cache.write("WishRoll:Cache:BlockRelationship:Blocker#{blocker_id}:Blocked#{blocked_id}", true)
    end

    after_destroy do
        logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:BlockRelationship:Blocker#{blocker_id}:Blocked#{blocked_id}"} if Rails.cache.delete("WishRoll:Cache:BlockRelationship:Blocker#{blocker_id}:Blocked#{blocked_id}")
    end
end
