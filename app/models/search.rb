class Search < ApplicationRecord
  validate :increment_occurences_count_on_duplicate_queries, on: :create
  has_one :location, as: :locateable, dependent: :destroy
  enum result_type: [:unknown, :roll, :post, :user, :location, :tag]
  
  #increment the occurences count of an already present search query if a duplicate query is attempting creation 
  def increment_occurences_count_on_duplicate_queries
    search = Search.where(query: query).first
    if search
      search.occurences += 1
      search.save!
      errors.add(:query, "Duplicate queries are not allowed")
    end
  end
  


  def create_location
    self.location.create!()
  end
  
end
