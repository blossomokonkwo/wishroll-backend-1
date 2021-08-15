class MutualRelationship < ApplicationRecord
  belongs_to :user, counter_cache: :mutual_relationships_count
  belongs_to :mutual, class_name: "User", counter_cache: :mutual_relationships_count
  # validations
  validate :mutual_id_and_user_id_must_be_different

  include IdentityCache
  cache_belongs_to :user
  cache_belongs_to :mutual

  def mutual_id_and_user_id_must_be_different    
    errors.add([:user_id, :mutual_id], "User id and mutual id must be different") if mutual_id == user_id
  end

  after_destroy :invalidate_cache_and_destroy_activities

  private def invalidate_cache_and_destroy_activities
    logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:MutualRelationship:#{user_id}:Mutual?#{mutual_id}"} if Rails.cache.delete("WishRoll:Cache:MutualRelationship:#{user_id}:Mutual?#{mutual_id}")
    Activity.where(content_id: id, active_user_id: mutual_id, user_id: user_id, activity_type: self.class.name).first.destroy
  end
  

  

end
