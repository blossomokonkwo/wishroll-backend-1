class User < ApplicationRecord
    has_secure_password
    #ensure that the password has a minmum length of 8 on the client side 
    validates :email, :uniqueness => {message: "The email you have entered is already taken"}, presence: {message: "Please enter an appropriate email address"}, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Please enter an appropriate email address"}, on: [:create, :update]
    validates :first_name, presence: {message: "Enter your first name so others now who you are"}
    validates :last_name, presence: {message: "Enter your last name so others know who you are"}
    validates :bio, length: {maximum:100, message: "Keep your bio short, so you have more time for people to find about who you really are" }
    validates :username, presence: {message: "Please enter a username"}, length: {maximum: 10, message: "Your username can only be atmost ten characters long"}, uniqueness: {message: "Please enter a unique username"}, format: {with: /[a-z0-9]/, message: "You username must be lowercase"}

    
    #Associations 

    #any given user can have many friends and be a friend to many other users
    has_and_belongs_to_many :friends, class_name: "User", join_table: "friends_table", foreign_key: :user_id, association_foreign_key: :friend_id
    
    #user customization
    has_one_attached :profile_image
end
