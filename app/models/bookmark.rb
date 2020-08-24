class Bookmark < ApplicationRecord
    belongs_to :bookmarkable, polymorphic: true, counter_cache: :bookmark_count, touch: true
    has_one :location, as: :locateable, dependent: :destroy
    belongs_to :user

    after_commit do
    end

    after_destroy do
        Rails.cache.delete("WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{bookmarkable.uuid}")
    end

    after_create do 
        Rails.cache.write("WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{bookmarkable.uuid}", true)
    end

    #cache API's 
    include IdentityCache

    cache_belongs_to :user
    cache_index :bookmarkable, :user
end
