class TrendingTag < ApplicationRecord
    validates :text, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 50}
    
    def posts(limit:, offset:)
        Post.fetch_multi(Tag.trending_tag(text).limit(limit).offset(offset).pluck(:post_id)).uniq {|p| p.id}      
    end
    
end
