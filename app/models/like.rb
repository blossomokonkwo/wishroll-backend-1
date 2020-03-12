class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count, touch: true
  belongs_to :user, class_name: "User"
end
