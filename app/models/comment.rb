class Comment < ApplicationRecord
  belongs_to :user, -> { select([:username, :id, :name, :verified, :avatar_url])}
  belongs_to :post, counter_cache: :comments_count, optional: true
  belongs_to :roll, counter_cache: :comments_count, optional: true
  has_many :replies, class_name: "Comment", foreign_key: :original_comment_id, dependent: :destroy
  belongs_to :original_comment, class_name: "Comment", optional: true, counter_cache: :replies_count
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :mentions, as: :mentionable, dependent: :destroy
  
  after_destroy do
    Activity.where(content_id: self.id, activity_type: self.class.name).destroy_all
  end

  def liked?(user)
    Rails.cache.fetch("WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{self.uuid}"){
      likes.where(user_id: user).exists?
    }
  end
  
  def extract_mentions(&block)
    body.scan(/@(\w+)/).flatten.each(&block) if block_given? and body
  end
  

  #cache API's
  include IdentityCache
  cache_belongs_to :post
  cache_belongs_to :roll

end
