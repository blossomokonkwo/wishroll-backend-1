class BoardMember < ApplicationRecord
  include IdentityCache 
  belongs_to :user
  belongs_to :board, counter_cache: :board_member_count
  cache_belongs_to :board
  cache_belongs_to :user
  cache_index :board_id, :user_id

  after_destroy do
    #  Clear the cache for the is_member method after a BoardMember is destroyed
    logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:Board:Member:#{user.id}:Board:#{board_id}"} if Rails.cache.delete("WishRoll:Cache:Board:Member:#{user.id}:Board:#{board_id}")
    user.touch; board.touch;
  end

end
