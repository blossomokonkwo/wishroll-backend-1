class Post < ApplicationRecord
    has_many :tags, -> {select([:id, :text])}, class_name: "Tag", dependent: :destroy
    has_many :comments, dependent: :destroy
    belongs_to :user, class_name: "User", foreign_key: "user_id"
    has_many :likes, as: :likeable, dependent: :destroy
    has_many :views, as: :viewable, dependent: :destroy
    has_many :shares, as: :shareable, dependent: :destroy
    has_many :viewers, through: :views, source: :user
    has_one :location, as: :locateable, dependent: :destroy
    has_many :bookmarks, as: :bookmarkable, dependent: :destroy
    belongs_to :album, optional: true, counter_cache: :post_count
    has_one_attached(:media_item)
    has_one_attached(:thumbnail_item)

    #returns a post's top comments - comments that have a null value for their original_comment_id field - which are basically non replies
    def top_comments(limit: 25, offset: nil)
        if offset
            self.comments.where('original_comment_id IS NULL AND created_at < ?', offset).includes(:user).order(created_at: :desc).limit(limit)
        else
            self.comments.where('original_comment_id IS NULL').order(created_at: :desc).limit(limit)
        end
    end

    def viewed?(user)
        Rails.cache.fetch("WishRoll:Cache:View:Viewer:#{user.id}:Viewed:#{self.uuid}") {
            self.views.find_by(user: user).present?
        }
        
    end
    
    def liked?(user)
        Rails.cache.fetch("WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{self.uuid}") {
            self.likes.find_by(user: user).present?
        }
    end

    def bookmarked?(user)
        Rails.cache.fetch("WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{self.uuid}") {
            self.bookmarks.find_by(user: user).present?
        }
    end
    

    #callbacks APIs 
    after_destroy do
        destroy_post_activities
    end



    private 
    def destroy_post_activities
        activities = Activity.where(content_id: self.id, activity_type: self.class.name)
        activities.find_each do |activity|
        activity.destroy
        end if activities.present?
    end

    #cache API's
    include IdentityCache

    cache_belongs_to :user
    cache_has_many :comments
    cache_has_many :views


end
