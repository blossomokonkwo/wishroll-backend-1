class Bookmark < ApplicationRecord
    belongs_to :bookmarkable, polymorphic: true, counter_cache: :bookmark_count, touch: true
    has_one :location, as: :locateable, dependent: :destroy
    belongs_to :user, -> { select([:username, :id, :name, :verified, :avatar_url])}, counter_cache: :total_num_bookmarks, touch: true

    after_commit do
    end

    after_destroy do
        Rails.cache.delete("WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{bookmarkable.uuid}")
        user = bookmarkable.user
        if bookmarkable.instance_of? Post
            user.post_bookmarks_count -= 1
        elsif bookmarkable.instance_of? Roll
            user.roll_bookmarks_count -= 1
        end
        user.save
    end

    after_create do 
        Rails.cache.write("WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{bookmarkable.uuid}", true)
        user = bookmarkable.user
        if bookmarkable.instance_of? Post
            user.post_bookmarks_count += 1
        elsif bookmarkable.instance_of? Roll
            user.roll_bookmarks_count += 1
        end
        user.save
    end
end
