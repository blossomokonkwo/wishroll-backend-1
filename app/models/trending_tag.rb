class TrendingTag < ApplicationRecord
    validates :title, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 50}
    
    def posts(limit:, offset:)
        Post.fetch_multi(Tag.trending_tag(title).limit(limit).offset(offset).pluck(:post_id)).uniq {|p| p.id}      
    end
    
end
