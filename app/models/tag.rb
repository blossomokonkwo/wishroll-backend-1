class Tag < ApplicationRecord
    include PgSearch::Model
    include IdentityCache
    belongs_to :post, class_name: "Post", foreign_key: :post_id, optional: true
    belongs_to :roll, class_name: "Roll", foreign_key: :roll_id, optional: true
    has_one :location, as: :locateable, dependent: :destroy
    validates :text, presence: true

    #search API's 
    pg_search_scope :search, against: :text, using: {tsearch: {dictionary: :english, prefix: true}}, order_within_rank: "tags.created_at DESC"
    pg_search_scope :recommend, against: :text, using: {tsearch: {dictionary: :english, tsvector_column: :tsv_text, any_word: true}}, order_within_rank: "tags.created_at DESC"
    pg_search_scope :trending_tag, against: :text, using: {tsearch: {dictionary: :english, tsvector_column: :tsv_text, prefix: true}}, order_within_rank: "tags.created_at ASC"

    after_create do
        self.update(tsv_text: self.text)
    end

end
