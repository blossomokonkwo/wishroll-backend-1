class Roll < ApplicationRecord
  #Associations
  belongs_to :user, counter_cache: :total_num_rolls
  has_many :hashtags, as: :hashtaggable, dependent: :destroy
  has_many :mentions, as: :mentionable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  has_many :shares, as: :shareable, dependent: :destroy
  has_one :location, as: :locateable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached(:media_item)
  has_one_attached(:thumbnail_image)

  #user interaction APIs
  def viewed?(user)
    Rails.cache.fetch("WishRoll:Cache:View:Viewer:#{user.id}:Viewed:#{uuid}") {
      views.find_by(user: user).present?
    }
  end

  def liked?(user)
    Rails.cache.fetch("WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{uuid}") {
      likes.find_by(user: user).present?
    }
  end

  def bookmarked?(user)
    Rails.cache.fetch("WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{uuid}") {
      bookmarks.find_by(user: user).present?
    }
  end

  after_destroy do
    Activity.where(content_id: id, activity_type: self.class.name).destroy_all
  end

  after_create do
    user.touch
  end

  #cache API's
  include IdentityCache
  cache_belongs_to :user

  #mention and hashtag APIs
  def extract_hashtags(&block)
    caption.scan(/#(\w+)/).flatten.each(&block) if block_given? and caption
  end

  def extract_mentions(&block)
    caption.scan(/@(\w+)/).flatten.each(&block) if block_given? and caption
  end

  #location APIs
  def country
    location.country_name if location
  end

  def city
    location.city if location
  end

  def continent
    location.continent if location
  end

  def state
    location.region if location
  end

  alias :region :state

end
