class Roll < ApplicationRecord
  #Associations
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, class_name: "Comment", foreign_key: :roll_id, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  has_many :reactions, class_name: "Roll", foreign_key: :original_roll_id
  has_many :shares, as: :shareable, dependent: :destroy
  belongs_to :original_roll, class_name: "Roll", optional: true, counter_cache: :reactions_count
  has_many :tags, class_name: "Tag", foreign_key: :roll_id, dependent: :destroy
  has_one :location, as: :locateable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable
  has_one_attached(:media_item)
  has_one_attached(:thumbnail_image)
  has_one_attached(:thumbnail_gif)
  after_create :create_reaction_activity

  def create_reaction_activity
    if original_roll_id
      phrase = "#{user.username} reacted to your roll!"
      reacted_user_id = Roll.find(original_roll_id).user_id
      unless reacted_user_id == user_id
        Activity.create(user_id: reacted_user_id, active_user_id: user_id, activity_phrase: phrase, activity_type: self.class.name, content_id: id, media_url: thumbnail_url)
      end
    end
  end

  #user interaction APIs
  def viewed?(user)
    Rails.cache.fetch([self, user]){
      views.find_by(user_id: id).present?
    }
  end

  def liked?(user)
    Rails.cache.fetch([self, user]){
      likes.find_by(user_id: id).present?
    }
    
  end

  def bookmarked?(user)
    Rails.cache.fetch([self, user]){
      bookmarks.find_by(user_id: user).present?
    }
  end
  

  #Comments API
  def top_comments(limit: 25, offset: nil)
    if offset
      
    else
      
    end
    
  end
  
end
