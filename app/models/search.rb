class Search < ApplicationRecord
  validates :query, presence: true
  has_many :locations, as: :locateable, dependent: :destroy
  belongs_to :user
  enum result_type: [:image, :video, :gif, :audio, :user, :location, :unknown]
end
