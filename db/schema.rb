# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_23_034355) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "active_user_id", null: false
    t.string "activity_type"
    t.bigint "content_id"
    t.string "activity_phrase"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "block_relationships", force: :cascade do |t|
    t.bigint "blocker_id", null: false
    t.bigint "blocked_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blocked_id"], name: "index_block_relationships_on_blocked_id"
    t.index ["blocker_id", "blocked_id"], name: "index_block_relationships_on_blocker_id_and_blocked_id", unique: true
    t.index ["blocker_id"], name: "index_block_relationships_on_blocker_id"
  end

  create_table "board_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "board_id", null: false
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_id"], name: "index_board_members_on_board_id"
    t.index ["is_admin"], name: "index_board_members_on_is_admin"
    t.index ["user_id", "board_id"], name: "index_board_members_on_user_id_and_board_id", unique: true
    t.index ["user_id"], name: "index_board_members_on_user_id"
  end

  create_table "boards", force: :cascade do |t|
    t.bigint "board_member_count", default: 0, null: false
    t.string "name", null: false
    t.text "description"
    t.string "banner_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar_url"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.boolean "featured", default: false, null: false
    t.bigint "posts_count", default: 0, null: false
    t.index ["featured"], name: "index_boards_on_featured"
    t.index ["name"], name: "index_boards_on_name", unique: true
    t.index ["posts_count"], name: "index_boards_on_posts_count"
    t.index ["uuid"], name: "index_boards_on_uuid"
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

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.bigint "likes_count", default: 0, null: false
    t.bigint "original_comment_id"
    t.bigint "replies_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["original_comment_id"], name: "index_comments_on_original_comment_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["uuid"], name: "index_comments_on_uuid"
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
    t.index ["likeable_type", "likeable_id", "user_id"], name: "index_likes_on_likeable_type_and_likeable_id_and_user_id", unique: true
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "mutual_relationship_requests", force: :cascade do |t|
    t.bigint "requesting_user_id", null: false
    t.bigint "requested_user_id", null: false
    t.boolean "accepted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["requested_user_id", "requesting_user_id"], name: "index_mutual_relationship_requests_users_uniqueness", unique: true
    t.index ["requested_user_id"], name: "index_mutual_relationship_requests_on_requested_user_id"
    t.index ["requesting_user_id"], name: "index_mutual_relationship_requests_on_requesting_user_id"
  end

  create_table "mutual_relationships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mutual_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mutual_id", "user_id"], name: "index_mutual_relationships_on_mutual_id_and_user_id", unique: true
    t.index ["mutual_id"], name: "index_mutual_relationships_on_mutual_id"
    t.index ["user_id"], name: "index_mutual_relationships_on_user_id"
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
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.integer "bookmark_count", default: 0, null: false
    t.float "popularity_rank", default: 0.0, null: false
    t.boolean "restricted", default: false
    t.float "width", default: 0.0, null: false
    t.float "height", default: 0.0, null: false
    t.float "duration", default: 0.0, null: false
    t.bigint "board_id"
    t.index ["board_id"], name: "index_posts_on_board_id"
    t.index ["caption"], name: "index_posts_on_caption"
    t.index ["media_url"], name: "index_posts_on_media_url"
    t.index ["popularity_rank"], name: "index_posts_on_popularity_rank"
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

  create_table "reported_posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.integer "reason", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id", "user_id"], name: "index_reported_posts_on_post_id_and_user_id", unique: true
    t.index ["post_id"], name: "index_reported_posts_on_post_id"
    t.index ["user_id"], name: "index_reported_posts_on_user_id"
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
    t.bigint "share_count", default: 0, null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.integer "bookmark_count", default: 0, null: false
    t.float "popularity_rank", default: 0.0
    t.boolean "featured", default: false, null: false
    t.boolean "private", default: false, null: false
    t.boolean "restricted", default: false, null: false
    t.bigint "hashtag_count", default: 0, null: false
    t.bigint "mention_count", default: 0, null: false
    t.float "width", default: 0.0, null: false
    t.float "height", default: 0.0, null: false
    t.float "duration", default: 0.0, null: false
    t.index ["media_url"], name: "index_rolls_on_media_url"
    t.index ["private"], name: "index_rolls_on_private"
    t.index ["restricted"], name: "index_rolls_on_restricted"
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

  create_table "shares", force: :cascade do |t|
    t.bigint "user_id"
    t.string "shareable_type"
    t.bigint "shareable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "shared_service", default: 0
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["user_id", "shareable_id", "shareable_type", "shared_service"], name: "index_unique_share", unique: true
    t.index ["user_id"], name: "index_shares_on_user_id"
    t.index ["uuid"], name: "index_shares_on_uuid"
  end

  create_table "tags", force: :cascade do |t|
    t.text "text"
    t.bigint "post_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.tsvector "tsv_text"
    t.index ["post_id"], name: "index_tags_on_post_id"
    t.index ["text"], name: "index_tags_on_text"
    t.index ["tsv_text"], name: "index_tags_on_tsv_text", using: :gin
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.boolean "verified", default: false, null: false
    t.date "birth_date"
    t.text "bio"
    t.string "avatar_url"
    t.bigint "followers_count", default: 0
    t.bigint "following_count", default: 0
    t.string "name"
    t.string "profile_background_url"
    t.boolean "restricted", default: false
    t.bigint "rolls_count", default: 0, null: false
    t.bigint "posts_count", default: 0, null: false
    t.bigint "mutual_relationships_count", default: 0, null: false
    t.jsonb "social_media"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mutual_relationships_count"], name: "index_users_on_mutual_relationships_count"
    t.index ["name"], name: "index_users_on_name"
    t.index ["restricted"], name: "index_users_on_restricted"
    t.index ["social_media"], name: "index_users_on_social_media", using: :gin
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["verified"], name: "index_users_on_verified"
  end

  create_table "views", force: :cascade do |t|
    t.bigint "user_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "users"
  add_foreign_key "board_members", "boards"
  add_foreign_key "board_members", "users"
  add_foreign_key "devices", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "mutual_relationships", "users"
  add_foreign_key "mutual_relationships", "users", column: "mutual_id"
  add_foreign_key "posts", "users"
  add_foreign_key "rolls", "users"
end
