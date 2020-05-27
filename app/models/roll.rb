class Roll < ApplicationRecord
  #Associations
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, class_name: "Comment", foreign_key: :roll_id, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  has_many :reactions, class_name: "Roll", foreign_key: :original_roll_id
  has_many :shares, as: :shareable, dependent: :destroy
  belongs_to :original_roll, class_name: "Roll", optional: true
  has_one :location, as: :locateable, dependent: :destroy
  has_one_attached(:media_item)
  has_one_attached(:thumbnail)



  #Comments API
  def top_comments(limit: 25, offset: nil)
    if offset
      
    else
      
    end
    
  end
  
end
