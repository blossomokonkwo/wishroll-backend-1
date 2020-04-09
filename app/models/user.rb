class User < ApplicationRecord
    has_secure_password
    #ensure that the password has a minmum length of 8 on the client side 
    validates :email, :uniqueness => {message: "The email you have entered is already taken"}, presence: {message: "Please enter an appropriate email address"}, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Please enter an appropriate email address"}, on: [:create, :update]
    validates :username, uniqueness: true, presence: {message: "You must provide a valid username"}, format: {with: /([a-z0-9])*/,message: "Your username must be lowercase and can not include symbols"}, on: [:create, :update]
    validates :birth_date, presence: {message: "Please enter your birthdate"}
    validates :bio, length: {maximum: 100, too_long: "%{count} is the maximum amount of characters allowed"}
    #every user can optionally upload a profile picture
    has_one_attached(:profile_picture)
    #Associations 
    has_many :posts, -> {order "created_at DESC"}, class_name: "Post"
    has_many :comments, class_name: "Comment"
    
    #a user can have many active relationships which relates a user to the account he / she follows through the Relationship model and the follower_id foreign key.
    has_many :active_relationships, -> {order "created_at DESC"},class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy

    #a user can have many passive relationships which relates a user to the accounts he / she follows through the Relationship model.
    has_many :passive_relationships, -> {order "created_at DESC"}, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy 
    
    has_and_belongs_to_many :blocked_users, -> { select([:username, :id])}, class_name: "User", join_table: :block_relationships, foreign_key: :blocker_id, association_foreign_key: :blocked_id
    
    #the users that a specific user is currently following 
    has_many :followed_users, through: :active_relationships, source: :followed_user

    #the users that currently follow a specific user 
    has_many :follower_users, through: :passive_relationships, source: :follower_user

    #has_many :blocked_users, through: :blocked_relationships, source: :blocked_user

    #all activities involving a user will be available when the user makes a request for https://domainname.com/activity
    #in a sense activity is a type of logger for each user to know the activities that involved their content on the app
    has_many :activities, class_name: "Activity", foreign_key: :user_id, dependent: :destroy

    #for now users won't be notified of the activities that they caused
    #for example, there wont be a "You just liked joe's post. I find that this is unneccessary and removes from the validity of the activity feed entirely"
    has_many :caused_activities, class_name: "Activity", foreign_key: :active_user_id

    scope :verified, -> { where(:is_verified => true)} #this scope returns all the verified users in the app
    # Ex:- scope :active, -> {where(:active => true)}

    has_many :wishlists, dependent: :destroy

    has_many :wishes, dependent: :destroy

    has_many :chat_room_users
    has_many :chat_rooms, through: :chat_room_users
    has_many :messages, foreign_key: :sender_id
    has_many :topics
    has_many :created_chatrooms, class_name: "ChatRoom", foreign_key: :creator_id
    has_many :devices, class_name: "Device", foreign_key: :user_id, dependent: :destroy
    #user has many reported posts. We use this array of reported posts to filter content that the user doesn't want to view. This property also allows administrators
    #to discover posts that users are reporting and find out if this post needs to be deleted of the app
    has_many :reported_posts_relationships, -> {order "created_at DESC"}, class_name: "UserBlockedPost", foreign_key: :user_id, dependent: :destroy
    has_many :reported_posts, through: :reported_posts_relationships, source: :post



    #cache methods

    def cached_reported_posts
        Rails.cache.fetch([self, "reported_posts"]) {reported_posts.to_a}
        #we convert the relation object to an array to make it clear that we are using a cached version of the reported_posts
        #remember to flush the cache when changing the data base schema
    end
end
