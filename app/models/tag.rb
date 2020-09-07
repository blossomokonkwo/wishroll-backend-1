class Tag < ApplicationRecord
    include PgSearch::Model
    include IdentityCache
    belongs_to :post, class_name: "Post", foreign_key: :post_id, optional: true
    belongs_to :roll, class_name: "Roll", foreign_key: :roll_id, optional: true
    has_one :location, as: :locateable, dependent: :destroy
    validates :text, presence: true

    #search API's 
    pg_search_scope :search, against: :text, using: {tsearch: {prefix: true, dictionary: "english", normalization: 16, any_word: true, tsvector_column: "tsv_text"}}, order_within_rank: "tags.created_at DESC"

    after_create do
        self.update(tsv_text: self.text)
    end

end
