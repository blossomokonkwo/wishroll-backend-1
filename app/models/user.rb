class User < ApplicationRecord
    has_secure_password
    #ensure that the password has a minmum length of 8 on the client side 
    validates :email, :uniqueness => {message: "The email you have entered is already taken"}, presence: {message: "Please enter an appropriate email address"}, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Please enter an appropriate email address"}, on: [:create, :update]
    #Associations 
    has_many :posts, class_name: "Post"
end
