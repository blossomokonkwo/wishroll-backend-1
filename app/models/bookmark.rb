class Bookmark < ApplicationRecord
    belongs_to :bookmarkable, polymorphic: true, counter_cache: :bookmark_count, touch: true
    has_one :location, as: :locateable, dependent: :destroy
    belongs_to :user

    after_commit do
        bookmarkable.update!(popularity_rank: (bookmarkable.view_count + bookmarkable.likes_count + bookmarkable.share_count + bookmarkable.bookmark_count) / ((Time.zone.now - bookmarkable.created_at.to_time) / 1.hour.seconds))
    end

    #cache API's 
    include IdentityCache

    cache_belongs_to :user
    cache_index :bookmarkable, :user
end
