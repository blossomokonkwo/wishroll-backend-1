class Visit < ApplicationRecord
    belongs_to :user, optional: true
    validates :visit_token, presence: {message: "A visit token must be present in order to create a new visit"}
    validates :visitor_token, presence: {message: "A visitor token must be present in order to create a new visit"}
end
