class Orginization < ApplicationRecord
    validates :name, presence: true, uniqueness: {message: "%{value} already exists"}
    has_many :users, lambda {readonly}
end
