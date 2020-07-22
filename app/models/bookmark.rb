class Bookmark < ApplicationRecord
    belongs_to :bookmarkable, polymorphic: true, counter_cache: :bookmark_count, touch: true
    has_one :location, as: :locateable, dependent: :destroy
    belongs_to :user

    after_commit do
        delta_time = ((Time.zone.now - bookmarkable.created_at.to_time) / 1.hour.seconds)
        if delta_time >= 48
          delta_time *= 4
        elsif delta_time >= 36
          delta_time *= 3.75
        elsif delta_time >= 32
          delta_time *= 3.5
        elsif delta_time >= 28
          delta_time *= 3.25
        elsif delta_time >= 24
          delta_time *= 3.15
        elsif delta_time >= 20
          delta_time *= 3
        elsif delta_time >= 19
          delta_time *= 2.9
        elsif delta_time >= 18
          delta_time *= 2.8
        elsif delta_time >= 17
          delta_time *= 2.7
        elsif delta_time >= 16
          delta_time *= 2.6
        elsif delta_time >= 15
          delta_time *= 2.5
        elsif delta_time >= 14
          delta_time *= 2.4
        elsif delta_time >= 13
          delta_time *= 2.3
        elsif delta_time >= 12
          delta_time *= 2.2
        elsif delta_time >= 11
          delta_time *= 2.1
        elsif delta_time >= 10
          delta_time *= 2.0
        elsif delta_time >= 9
          delta_time *= 1.9
        elsif delta_time >= 8
          delta_time *= 1.8
        elsif delta_time >= 7
          delta_time *= 1.7
        elsif delta_time >= 6
          delta_time *= 1.6
        elsif delta_time >= 5
          delta_time *= 1.5
        elsif delta_time >= 4
          delta_time *= 1.4
        elsif delta_time >= 3
          delta_time *= 1.3
        elsif delta_time >= 2
          delta_time *= 1.2
        elsif delta_time >= 1.5
          delta_time *= 1.15
        elsif delta_time >= 1
          delta_time *= 1.1
        else 
          delta_time *= 1
        end
        bookmarkable.update!(popularity_rank: (bookmarkable.view_count + bookmarkable.likes_count + bookmarkable.share_count + bookmarkable.bookmark_count) / delta_time)
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
