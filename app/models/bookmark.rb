class Bookmark < ApplicationRecord
    belongs_to :bookmarkable, polymorphic: true, counter_cache: :bookmark_count, touch: true
    has_one :location, as: :locateable, dependent: :destroy
    belongs_to :user
end
