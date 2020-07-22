class Story < ApplicationRecord
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  has_many :shares, as: :shareable, dependent: :destroy
  has_one :location, as: :locateable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable





  #cache API's 

def viewed?(user)
  Rails.cache.fetch("WishRoll:Cache:View:Viewer:#{user.id}:Viewed:#{self.uuid}") {
      self.views.find_by(user: user).present?
  }
end

def liked?(user)
    Rails.cache.fetch("WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{self.uuid}") {
        self.likes.find_by(user: user).present?
    }
end

def bookmarked?(user)
    Rails.cache.fetch("WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{self.uuid}") {
        self.bookmarks.find_by(user: user).present?
    }
end

include IdentityCache

cache_belongs_to :user
cache_has_many :comments
cache_has_many :views


end
