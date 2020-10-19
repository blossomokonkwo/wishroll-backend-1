class Comment < ApplicationRecord
  belongs_to :user, -> { select([:username, :id, :name, :verified, :avatar_url, :total_num_comments, :post_comments_count, :roll_comments_count])}, counter_cache: :total_num_comments
  belongs_to :post, counter_cache: :comments_count, optional: true
  belongs_to :roll, counter_cache: :comments_count, optional: true
  has_many :replies, class_name: "Comment", foreign_key: :original_comment_id, dependent: :destroy
  belongs_to :original_comment, class_name: "Comment", optional: true, counter_cache: :replies_count
  has_many :likes, as: :likeable, dependent: :destroy
  
  after_destroy do
    if roll
      creator = roll.user
      creator.roll_comments_count -= 1
      creator.save!
  elsif post
      creator = post.user
      creator.post_comments_count -= 1
      creator.save!
  end
    Activity.where(content_id: self.id, activity_type: self.class.name).destroy_all
  end

  after_create do
    if roll
      roll.user.roll_comments_count += 1
      roll.user.save!
    elsif post
      post.user.post_comments_count += 1
      post.user.save!
    end
  end

  def liked?(user)
    Rails.cache.fetch("WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{self.uuid}"){
      likes.where(user_id: user).exists?
    }
  end

  #cache API's
  include IdentityCache
  cache_belongs_to :post

end
