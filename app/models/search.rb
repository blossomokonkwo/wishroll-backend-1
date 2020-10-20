class Search < ApplicationRecord
  validates :query, presence: true
  belongs_to :user, counter_cache: :total_num_searches
  enum result_type: [:image, :video, :gif, :audio, :user, :location, :unknown]

  after_create do
    user.total_num_searches += 1
    user.save
  end

end
