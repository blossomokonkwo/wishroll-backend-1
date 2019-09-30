class User < ApplicationRecord
    has_secure_password
    validates :email, :uniqueness => {message: "The email you have entered is already taken"}, presence: {message: "Please enter an appropriate email address"}, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Please enter an appropriate email address"}, on: [:create, :update]
    validates :first_name, presence: {message: "Enter your first name so others now who you are"}
    validates :last_name, presence: {message: "Enter your last name so others know who you are"}
    validates :bio, length: {maximum:100, message: "Keep your bio short, so you have more time for people to find about who you really are" }
end
