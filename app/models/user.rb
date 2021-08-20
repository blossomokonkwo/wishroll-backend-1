class User < ApplicationRecord
    include PgSearch::Model
    include IdentityCache
    acts_as_reader
    has_secure_password
    validates :email, :uniqueness => {message: "The email you have entered is already taken"}, presence: {message: "Please enter an appropriate email address"}, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Please enter an appropriate email address"}, on: [:create, :update]
    validates :username, uniqueness: true, presence: {message: "You must provide a valid username"}, exclusion: {in: %w(logout login signup signup home refresh terms privacy help account), message: "%{value} is reserved"}, format: {with: /[a-z0-9]([._](?![._])|[a-z0-9]){1,20}[a-z0-9]/, message: "Your username must be lowercase and can not include symbols"}, on: [:create, :update]
    validates :bio, length: {maximum: 100, too_long: "%{count} is the maximum amount of characters allowed"}
    has_one_attached(:avatar) #users can display an image or video as their profile avatar
    has_one_attached(:profile_background_media) #users can display a background image or video on their profile background 
    
    
    #Associations 
    enum gender: [:male, :female, :unspecified]
    has_one :location, as: :locateable, dependent: :destroy    
    has_many :visits
    has_many :posts, -> {order(created_at: :desc)}, dependent: :destroy
    has_many :rolls, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :views
    has_many :shares
    has_many :likes, dependent: :destroy
    has_many :bookmarks, dependent: :destroy 
    has_many :searches
    has_many :created_mentions, class_name: "Mention", foreign_key: :user_id, dependent: :destroy
    has_many :mentions, class_name: "Mention", foreign_key: :mentioned_user_id, dependent: :destroy
    has_many :hashtags, dependent: :destroy

    #cache API's 
    cache_index :username, unique: true
    cache_index :name
    cache_has_many :posts

    def liked_posts(limit: 25, offset: nil)
        Post.select([:id, :created_at, :updated_at, :caption, :media_url, :thumbnail_url, :view_count, :likes_count, :comments_count, :bookmark_count, :share_count, :user_id, :uuid, :width, :height, :duration])
        .joins(:likes)
        .order("likes.created_at DESC")
        .where(likes: {user: self})
        .offset(offset)
        .limit(limit) 
    end
    
    def created_posts(limit: 25, offset: nil, reported_posts: nil)
        Post.select([:id, :created_at, :updated_at, :caption, :media_url, :thumbnail_url, :view_count, :likes_count, :comments_count, :bookmark_count, :share_count, :user_id, :uuid, :width, :height, :duration])
        .where(user: self)
        .where.not(id: reported_posts)
        .order(created_at: :desc)
        .offset(offset)
        .limit(limit)
    end

    def created_rolls(limit: 25, offset:)
        Roll.select([:id, :created_at, :updated_at, :caption, :media_url, :thumbnail_url, :view_count, :likes_count, :comments_count, :bookmark_count, :share_count, :user_id, :uuid, :width, :height, :duration])
        .where(user: self)
        .order(created_at: :desc)
        .offset(offset)
        .limit(limit)
    end

    def liked_rolls(limit: 25, offset:)
        Roll.select([:id, :created_at, :updated_at, :caption, :media_url, :thumbnail_url, :view_count, :likes_count, :comments_count, :bookmark_count, :share_count, :user_id, :uuid, :width, :height, :duration])
        .joins(:likes)
        .where(likes: {user: self})
        .order("likes.created_at DESC")
        .offset(offset)
        .limit(limit)
    end
    
    
    def bookmarked_posts(limit: 25, offset:)
        Post.select([:id, :created_at, :updated_at, :caption, :media_url, :thumbnail_url, :view_count, :likes_count, :comments_count, :bookmark_count, :share_count, :user_id, :uuid, :width, :height, :duration])
        .joins(:bookmarks, media_item_attachment: :blob)
        .where(bookmarks: {user: self})
        .order("bookmarks.created_at DESC")
        .offset(offset)
        .limit(limit)
    end

    #returns all of the posts that a user has shared
    def shared_posts(limit: 25, offset: nil)
        Post.select([:id, :created_at, :updated_at, :caption, :media_url, :thumbnail_url, :view_count, :likes_count, :comments_count, :bookmark_count, :share_count, :user_id, :uuid, :width, :height, :duration])
        .joins(:shares)
        .where(shares: {user: self})
        .offset(offset)
        .order("shares.created_at DESC")
        .limit(limit)       
    end

    #Returns all of the posts that a user has viewed with a default limit of 25 records and no offset
    def viewed_posts(limit: 25, offset: nil)
        Post.select([:id, :created_at, :updated_at, :caption, :media_url, :thumbnail_url, :view_count, :likes_count, :comments_count, :bookmark_count, :share_count, :user_id, :uuid, :width, :height, :duration])
        .joins(:views)
        .where(views: {user: self})
        .order("views.created_at DESC")
        .offset(offset)
        .limit(limit)      
    end

    #search apis
    pg_search_scope :search, against: {username: 'A', name: 'B'}, using: {tsearch: {prefix: true, any_word: true}}

    #location APIs
    def state
        location.region if location
    end

    alias :region :state

    def american?
        country == 'United States of America'
    end

    def country
        location.country_name if location
    end

    def city
        location.city if location
    end

    def continent
        location.continent if location
    end

    #a user can have many active relationships which relates a user to the account he / she follows through the Relationship model and the follower_id foreign key.
    has_many :active_relationships, -> {order(created_at: :desc, id: :desc)}, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy

    #a user can have many passive relationships which relates a user to the accounts he / she follows through the Relationship model.
    has_many :passive_relationships, -> {order(created_at: :desc, id: :desc)}, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy 
    
    has_many :active_block_relationships, class_name: "BlockRelationship", foreign_key: :blocker_id

    has_many :passive_block_relationships, class_name: "BlockRelationship", foreign_key: :blocked_id

    has_many :sent_mutual_relationship_requests, class_name: "MutualRelationshipRequest", foreign_key: :requesting_user_id, dependent: :destroy

    has_many :recieved_mutual_relationship_requests, class_name: "MutualRelationshipRequest", foreign_key: :requested_user_id, dependent: :destroy
    
    #the users that a specific user is currently following 
    has_many :followed_users, -> { select ([:username, :id, :name, :verified, :avatar_url, :following_count])}, through: :active_relationships, source: :followed_user

    #the users that currently follow a specific user 
    has_many :follower_users, -> { select ([:username, :id, :name, :verified, :avatar_url, :followers_count])}, through: :passive_relationships, source: :follower_user

    has_many :blocked_users, through: :active_block_relationships, source: :blocked_user

    has_many :blocker_users, through: :passive_block_relationships, source: :blocker_user

    #the activities that have happended to the user
    has_many :activities, -> {order(created_at: :desc)}, class_name: "Activity", foreign_key: :user_id, dependent: :destroy

    #the activities that a user has caused
    has_many :caused_activities, class_name: "Activity", foreign_key: :active_user_id

    scope :verified, -> { where(:verified => true)} #this scope returns all the verified users in the app

    #joins table that joins the chat room and user model. A ChatRoomUser model is a user that is a member of a particular chat room
    has_many :chat_room_users, dependent: :destroy

    #all of the chat rooms that a user is a member of
    has_many :chat_rooms, through: :chat_room_users

    #all of the messages that a user has created
    has_many :messages, foreign_key: :sender_id, dependent: :destroy

    #all of the topics that a user has created
    has_many :topics

    #all of the chat rooms that a user is responsible for creating 
    has_many :created_chatrooms, class_name: "ChatRoom", foreign_key: :creator_id, dependent: :destroy

    # Joins table that joins the chat room and user model. A ChatRoomUser model is a user that is a member of a particular chat room.
    has_many :board_members, dependent: :destroy

    # All of the boards that a user is a member of
    has_many :boards, through: :board_members

    #a user can have multiple devices
    has_many :devices, class_name: "Device", foreign_key: :user_id, dependent: :destroy
    
    #returns a users must current device
    has_one :current_device, -> {where(current_device: true).limit(1)}, class_name: "Device", foreign_key: :user_id, dependent: :destroy

    has_many :reported_posts_relationships, class_name: "ReportedPost", foreign_key: :user_id, dependent: :destroy

    has_many :reported_posts, through: :reported_posts_relationships, source: :post
    # Convenience Methods

    def cached_reported_posts
        # Rails.cache.fetch([self, "reported_posts"]) {reported_posts.to_a}
        #we convert the relation object to an array to make it clear that we are using a cached version of the reported_posts
        #remember to flush the cache when changing the data base schema
    end

    def blocked?(user)
        # Rails.cache.fetch("WishRoll:Cache:BlockRelationship:Blocker#{self.id}:Blocked#{user.id}") {self.blocked_users.include?(user)}
        blocked_users.include?(user)
    end

    def self.current_user(user_id)
        User.find(user_id)
    end

    def following?(user)
        Rails.cache.fetch("WishRoll:Cache:Relationship:Follower#{self.id}:Following#{user.id}"){
            followed_users.include?(user)
        }
    end

    def mutuals(limit: nil, offset: 0) 
        created_mutual_relationships = MutualRelationship.where(user: self).limit(limit).offset(offset).pluck(:mutual_id)
        recieved_mutual_relationships = MutualRelationship.where(mutual: self).limit(limit).offset(offset).pluck(:user_id)
        return User.where(user_id: (created_mutual_relationships + recieved_mutual_relationships))
    end

    def mutual?(user) 
        Rails.cache.fetch("WishRoll:Cache:MutualRelationship:#{self.id}:Mutual?#{user.id}") {
            mutuals.include?(user)
        }
    end

    def mutual_status_with?(user)
        if MutualRelationship.find_by("(user_id = #{id} AND mutual_id = #{user.id}) OR (user_id = #{user.id} AND mutual_id = #{id})").present?
            return "mutuals"
        elsif MutualRelationshipRequest.find_by(requested_user_id: user.id, requesting_user_id: id)
            return "pending_recieved"
        elsif MutualRelationshipRequest.find_by(requested_user_id: self.id, requesting_user_id: user.id)
            return "pending_sent"
        else
            return "none"
        end
    end
    
end
