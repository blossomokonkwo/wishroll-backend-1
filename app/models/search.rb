class Search < ApplicationRecord
  validates :query, presence: true
  has_many :locations, as: :locateable, dependent: :destroy
  enum result_type: [:unknown, :roll, :post, :user, :location, :tag]
end
