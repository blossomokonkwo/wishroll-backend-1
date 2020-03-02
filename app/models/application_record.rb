class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
   
    connects_to database: { writing: :primary, reading: :primary_replica }
  end
end
