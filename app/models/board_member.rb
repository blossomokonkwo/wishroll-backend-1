class BoardMember < ApplicationRecord
  include IdentityCache 
  belongs_to :user
  belongs_to :board, counter_cache: :board_member_count
  cache_belongs_to :board
  cache_belongs_to :user
  cache_index :board_id, :user_id

  def board_posts(limit: 15, offset: 0)
    Post.where(board_id: board_id, user_id: user_id).limit(limit).offset(offset)
  end
  

  after_destroy do
    #  Clear the cache for the is_member method after a BoardMember is destroyed
    logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:Board:Member:#{user.id}:Board:#{board.uuid}"} if Rails.cache.delete("WishRoll:Cache:Board:Member:#{user.id}:Board:#{board.uuid}")
    user.touch; board.touch;
  end
  

end
