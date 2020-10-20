class Mention < ApplicationRecord
    belongs_to :mentionable, polymorphic: true, counter_cache: :mention_count, touch: true
    belongs_to :user, -> { select([:username, :id, :name, :verified, :avatar_url, :total_num_created_mentions])}, counter_cache: :total_num_created_mentions
    belongs_to :mentioned_user, -> { select([:username, :id, :name, :verified, :avatar_url, :total_num_mentioned])}, class_name: "User", foreign_key: :mentioned_user_id, counter_cache: :total_num_mentioned
end
