# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_13_205436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "active_user_id", null: false
    t.string "activity_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "activity_phrase", null: false
    t.bigint "content_id"
    t.string "media_url"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "fullname"
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.index ["email"], name: "index_admin_users_on_email"
  end

  create_table "albums", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.boolean "private", default: false
    t.bigint "post_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "thumbnail_url"
    t.index ["name"], name: "index_albums_on_name"
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "block_relationships", force: :cascade do |t|
    t.bigint "blocker_id", null: false
    t.bigint "blocked_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blocked_id"], name: "index_block_relationships_on_blocked_id"
    t.index ["blocker_id"], name: "index_block_relationships_on_blocker_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.string "bookmarkable_type"
    t.bigint "bookmarkable_id"
    t.bigint "user_id", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bookmarkable_type", "bookmarkable_id"], name: "index_bookmarks_on_bookmarkable_type_and_bookmarkable_id"
    t.index ["user_id", "bookmarkable_id", "bookmarkable_type"], name: "index_on_user_id_and_bookmarkable", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "chat_room_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chat_room_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "appearance", default: false
    t.datetime "last_seen"
    t.boolean "muted", default: false
    t.index ["chat_room_id"], name: "index_chat_room_users_on_chat_room_id"
    t.index ["user_id", "chat_room_id"], name: "index_chat_room_users_on_user_id_and_chat_room_id", unique: true
    t.index ["user_id"], name: "index_chat_room_users_on_user_id"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.bigint "topic_id"
    t.string "name"
    t.bigint "num_users", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "creator_id", null: false
    t.index ["creator_id"], name: "index_chat_rooms_on_creator_id"
    t.index ["name"], name: "index_chat_rooms_on_name"
    t.index ["topic_id"], name: "index_chat_rooms_on_topic_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id", null: false
    t.bigint "post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "original_comment_id"
    t.bigint "replies_count", default: 0
    t.bigint "likes_count", default: 0
    t.bigint "roll_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["original_comment_id"], name: "index_comments_on_original_comment_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["roll_id"], name: "index_comments_on_roll_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "device_token"
    t.string "platform"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "current_device", default: false
    t.index ["device_token"], name: "index_devices_on_device_token"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "likeable_type"
    t.bigint "likeable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "locateable_type"
    t.bigint "locateable_id"
    t.float "latitude"
    t.decimal "longitude"
    t.string "city"
    t.string "country"
    t.string "ip"
    t.string "region"
    t.string "timezone"
    t.integer "postal_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["city"], name: "index_locations_on_city"
    t.index ["country"], name: "index_locations_on_country"
    t.index ["latitude"], name: "index_locations_on_latitude"
    t.index ["locateable_type", "locateable_id"], name: "index_locations_on_locateable_type_and_locateable_id"
    t.index ["longitude"], name: "index_locations_on_longitude"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.string "media_url"
    t.bigint "sender_id", null: false
    t.bigint "chat_room_id", null: false
    t.string "kind", null: false
    t.string "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
    t.index ["uuid"], name: "index_messages_on_uuid"
  end

  create_table "posts", force: :cascade do |t|
    t.text "caption"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "view_count", default: 0, null: false
    t.bigint "comments_count", default: 0
    t.bigint "likes_count", default: 0
    t.string "media_url"
    t.string "thumbnail_url"
    t.bigint "share_count", default: 0, null: false
    t.string "content_type"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.integer "bookmark_count", default: 0, null: false
    t.float "popularity_rank", default: 0.0, null: false
    t.bigint "album_id"
    t.boolean "restricted", default: false
    t.index ["media_url"], name: "index_posts_on_media_url"
    t.index ["restricted"], name: "index_posts_on_restricted"
    t.index ["thumbnail_url"], name: "index_posts_on_thumbnail_url"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "followed_id"
    t.integer "follower_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id", "follower_id"], name: "index_relationships_on_followed_id_and_follower_id", unique: true
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "rolls", force: :cascade do |t|
    t.string "media_url"
    t.bigint "user_id", null: false
    t.bigint "view_count", default: 0
    t.string "caption"
    t.bigint "comments_count", default: 0
    t.string "thumbnail_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "likes_count", default: 0
    t.bigint "original_roll_id"
    t.bigint "share_count", default: 0, null: false
    t.string "content_type"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "thumbnail_gif_url"
    t.bigint "reactions_count", default: 0
    t.integer "bookmark_count", default: 0, null: false
    t.float "popularity_rank", default: 0.0
    t.boolean "private", default: false, null: false
    t.bigint "album_id"
    t.index ["media_url"], name: "index_rolls_on_media_url"
    t.index ["original_roll_id"], name: "index_rolls_on_original_roll_id"
    t.index ["thumbnail_url"], name: "index_rolls_on_thumbnail_url"
    t.index ["user_id"], name: "index_rolls_on_user_id"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
    t.text "apn_key"
    t.string "apn_key_id"
    t.string "team_id"
    t.string "bundle_id"
    t.boolean "feedback_enabled", default: true
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token"
    t.datetime "failed_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token"
    t.string "sound"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at"
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at"
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "alert_is_json", default: false, null: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after"
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false, null: false
    t.text "notification"
    t.boolean "mutable_content", default: false, null: false
    t.string "external_device_id"
    t.string "thread_id"
    t.boolean "dry_run", default: false, null: false
    t.boolean "sound_is_json", default: false
    t.index ["delivered", "failed", "processing", "deliver_after", "created_at"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "searches", force: :cascade do |t|
    t.string "query", null: false
    t.bigint "occurences", default: 1, null: false
    t.integer "result_type", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["query", "result_type"], name: "index_searches_on_query_and_result_type", unique: true
  end

  create_table "shares", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "shareable_type"
    t.bigint "shareable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "shared_service", default: 0
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["user_id", "shareable_id", "shareable_type", "shared_service"], name: "index_unique_share", unique: true
    t.index ["user_id", "shareable_id"], name: "index_shares_on_user_id_and_shareable_id", unique: true
    t.index ["user_id"], name: "index_shares_on_user_id"
    t.index ["uuid"], name: "index_shares_on_uuid"
  end

  create_table "tags", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "post_id"
    t.bigint "roll_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["post_id"], name: "index_tags_on_post_id"
    t.index ["roll_id"], name: "index_tags_on_roll_id"
    t.index ["text"], name: "index_tags_on_text"
  end

  create_table "topics", force: :cascade do |t|
    t.boolean "hot_topic", default: false
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "media_url"
    t.bigint "user_id", null: false
    t.index ["title"], name: "index_topics_on_title"
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "user_blocked_posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.string "reason", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_user_blocked_posts_on_post_id"
    t.index ["user_id"], name: "index_user_blocked_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.boolean "verified", default: false, null: false
    t.date "birth_date", null: false
    t.text "bio"
    t.string "avatar_url"
    t.bigint "followers_count", default: 0
    t.bigint "following_count", default: 0
    t.string "name"
    t.bigint "view_count", default: 0, null: false
    t.string "profile_background_url"
    t.integer "gender", default: 2
    t.bigint "wishroll_score", default: 0, null: false
    t.boolean "restricted", default: false
    t.index ["email"], name: "email"
    t.index ["name"], name: "index_users_on_name"
    t.index ["restricted"], name: "index_users_on_restricted"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "viewable_type"
    t.bigint "viewable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "duration"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["user_id", "viewable_id", "viewable_type"], name: "index_views_on_user_id_and_viewable_id_and_viewable_type", unique: true
    t.index ["user_id"], name: "index_views_on_user_id"
    t.index ["uuid"], name: "index_views_on_uuid"
    t.index ["viewable_id"], name: "index_views_on_viewable_id"
    t.index ["viewable_type", "viewable_id"], name: "index_views_on_viewable_type_and_viewable_id"
  end

  create_table "wishes", force: :cascade do |t|
    t.decimal "price", precision: 8, scale: 2, default: "0.0", null: false, comment: "The price for a wish"
    t.bigint "user_id", null: false
    t.text "description"
    t.string "image_url"
    t.string "product_name", null: false
    t.float "amount_covered", default: 0.0, comment: "The amount covered so far for a specific wish"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "wishlist_id"
    t.index ["user_id"], name: "index_wishes_on_user_id"
    t.index ["wishlist_id"], name: "index_wishes_on_wishlist_id"
  end

  create_table "wishlists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "wishes_count", default: 0
    t.float "total_amount_raised", default: 0.0, comment: "This column stores the total caches the total amount of money raised for all wishes in a users wishlist"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "users"
  add_foreign_key "chat_room_users", "chat_rooms"
  add_foreign_key "chat_room_users", "users"
  add_foreign_key "chat_rooms", "users", column: "creator_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "rolls"
  add_foreign_key "comments", "users"
  add_foreign_key "devices", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "messages", "chat_rooms"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "posts", "users"
  add_foreign_key "rolls", "users"
  add_foreign_key "shares", "users"
  add_foreign_key "tags", "posts"
  add_foreign_key "tags", "rolls"
  add_foreign_key "topics", "users"
  add_foreign_key "user_blocked_posts", "posts"
  add_foreign_key "user_blocked_posts", "users"
  add_foreign_key "views", "users"
  add_foreign_key "wishes", "users"
  add_foreign_key "wishes", "wishlists"
  add_foreign_key "wishlists", "users"
end
