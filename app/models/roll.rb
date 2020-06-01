class Roll < ApplicationRecord
  #Associations
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, class_name: "Comment", foreign_key: :roll_id, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  has_many :reactions, class_name: "Roll", foreign_key: :original_roll_id
  has_many :shares, as: :shareable, dependent: :destroy
  belongs_to :original_roll, class_name: "Roll", optional: true, counter_cache: :reactions_count
  has_many :tags, class_name: "Tag", foreign_key: :roll_id
  has_one :location, as: :locateable, dependent: :destroy
  has_one_attached(:media_item)
  has_one_attached(:thumbnail_image)
  has_one_attached(:thumbnail_gif)
  after_create :create_reaction_activity

  def create_reaction_activity
    if self.original_roll_id
      phrase = "#{self.user.username} reacted to your roll!"
      user_id = Roll.find(self.original_roll_id).user.id
      unless user_id == self.user.id
        Activity.create(user_id: user_id, active_user_id: self.user.id, activity_phrase: phrase, activity_type: self.class.name, content_id: self.id, media_url: self.media_url)
      end
    end
  end

  #user interaction APIs
  def viewed?(id)
    views.find_by(user_id: id).present?
  end

  def liked?(id)
    likes.find_by(user_id: id).present?
  end

  #Comments API
  def top_comments(limit: 25, offset: nil)
    if offset
      
    else
      
    end
    
  end
  
end
