class Search < ApplicationRecord
  validates :query, presence: true
  belongs_to :user, optional: true
  enum result_type: [:image, :video, :gif, :audio, :user, :location, :unknown]
end
