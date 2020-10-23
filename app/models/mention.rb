class Mention < ApplicationRecord
    belongs_to :mentionable, polymorphic: true, counter_cache: :mention_count, touch: true
    belongs_to :user, -> { select([:username, :id, :name, :verified, :avatar_url])}
    belongs_to :mentioned_user, -> { select([:username, :id, :name, :verified, :avatar_url])}, class_name: "User", foreign_key: :mentioned_user_id
end
