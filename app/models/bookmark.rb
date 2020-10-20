class Bookmark < ApplicationRecord
    belongs_to :bookmarkable, polymorphic: true, counter_cache: :bookmark_count, touch: true
    belongs_to :user, -> { select([:username, :id, :name, :verified, :avatar_url])}, counter_cache: :total_num_bookmarks, touch: true

    after_destroy do
        logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{bookmarkable.uuid}"} if Rails.cache.delete("WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{bookmarkable.uuid}")
        if creator = bookmarkable.user
            if bookmarkable.instance_of? Post
                creator.post_bookmarks_count -= 1
            elsif bookmarkable.instance_of? Roll
                creator.roll_bookmarks_count -= 1
            end
            creator.save
        end
    end

    after_create do 
        logger.debug {"[WishRoll Cache] write succeeded for WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{bookmarkable.uuid}"} if Rails.cache.write("WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{bookmarkable.uuid}", true)
        if creator = bookmarkable.user
            if bookmarkable.instance_of? Post
                creator.post_bookmarks_count += 1
            elsif bookmarkable.instance_of? Roll
                creator.roll_bookmarks_count += 1
            end
            creator.save
        end
    end
end
