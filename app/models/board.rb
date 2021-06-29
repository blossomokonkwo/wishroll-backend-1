class Board < ApplicationRecord
    include IdentityCache

    #Active Record Attachments
    has_one_attached :avatar
    has_one_attached :banner

    # Validations
    validates :name, presence: true, length: {minimum: 2, maximum: 100}, uniqueness: true
    validates :description, length: {maximum: 300}

    # Associations
    has_many :board_members, dependent: :destroy
    
    has_many :users, through: :board_members

    has_many :posts

    # Cache Associations
    cache_has_many :board_members

    # Returns a boards admin users 
    def admins
        # Use the where clause to return users who have admin column set to true (false by default)
        board_members.where(is_admin: true)
    end

    def member?(user)
        Rails.cache.fetch("WishRoll:Cache:Board:Member:#{user.id}:Board:#{id}") {
            board_members.where(user: user).present?
        }        
    end
    
    
end
