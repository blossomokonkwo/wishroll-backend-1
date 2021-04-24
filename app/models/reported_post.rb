class ReportedPost < ApplicationRecord
    belongs_to :user, foreign_key: :user_id
    belongs_to :post, foreign_key: :post_id
    enum reason: [:unknown, :racist, :hate, :pornographic, :violent, :homophobic, :spam, :insensitive, :sexist, :other]
end
