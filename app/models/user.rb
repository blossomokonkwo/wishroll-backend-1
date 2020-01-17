class User < ApplicationRecord
    has_secure_password
    #ensure that the password has a minmum length of 8 on the client side 
    validates :email, :uniqueness => {message: "The email you have entered is already taken"}, presence: {message: "Please enter an appropriate email address"}, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Please enter an appropriate email address"}, on: [:create, :update]
    validates :username, uniqueness: true, presence: {message: "You must provide a valid username"}, format: {with: /([a-z0-9])*/,message: "Your username must be lowercase and can not include symbols"}, on: [:create, :update]
    validates :first_name, presence: {message: "Please enter a first name"}, format: {with: /([A-Za-z])*/}, on: [:create, :update]
    validates :last_name, presence: {message: "Please enter an appropriate last name"}, format: { with: /([A-Za-z])*/}, on: [:create, :update]
    validates :birth_date, presence: {message: "Please enter your birthdate"}
    validates :bio, length: {maximum: 100, too_long: "%{count} is the maximum amount of characters allowed"}
    #every user can optionally upload a profile picture
    has_one_attached(:profile_picture)
    #Associations 
    has_many :posts, class_name: "Post"
    has_many :comments, class_name: "Comment"
    has_many :replies, class_name: "Reply"
end
