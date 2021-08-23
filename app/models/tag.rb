class Tag < ApplicationRecord
    include PgSearch::Model
    belongs_to :post
    validates :text, presence: true

    #search API's 
    pg_search_scope :search, against: :text, using: {tsearch: {dictionary: :english, tsvector_column: :tsv_text, prefix: true}}, order_within_rank: "tags.created_at DESC"
    pg_search_scope :recommend, against: :text, using: {tsearch: {dictionary: :english, tsvector_column: :tsv_text, any_word: true}}, order_within_rank: "tags.created_at DESC"
    pg_search_scope :trending_tag, against: :text, using: {tsearch: {dictionary: :english, tsvector_column: :tsv_text, prefix: true}}, order_within_rank: "tags.created_at ASC"

    # Caching API
    include IdentityCache
    cache_belongs_to :post
end
