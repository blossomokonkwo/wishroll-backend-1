class Hashtag < ApplicationRecord
    include PgSearch::Model
    belongs_to :hashtaggable, polymorphic: true, counter_cache: :hashtag_count, touch: true
    belongs_to :user, counter_cache: :total_num_hashtags
    has_one :location, as: :locateable, dependent: :destroy
    validates :text, presence: true
    pg_search_scope :search, against: :text, using: {tsearch: {dictionary: :english, tsvector_column: :tsv_text}}, order_within_rank: "hashtags.created_at DESC"
    after_create do
        update(tsv_text: text)
    end
end
