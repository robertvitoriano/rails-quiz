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

ActiveRecord::Schema[7.1].define(version: 2024_06_22_081139) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "course_battle_messages", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "message"
    t.binary "course_battle_id", limit: 36
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_battle_id"], name: "fk_rails_f31e0e68da"
    t.index ["user_id"], name: "fk_rails_b3c74d0e53"
  end

  create_table "course_battle_users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.column "result", "enum('won','lost','awaiting-opponent','not-finished','draw')", default: "not-finished", null: false
    t.decimal "performance", precision: 10
    t.integer "time_spent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "course_battle_id", limit: 36, null: false
    t.index ["course_battle_id"], name: "fk_rails_319dec625f"
    t.index ["user_id"], name: "fk_rails_ab2a5d20a2"
  end

  create_table "course_battles", id: { type: :binary, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "fk_rails_5784485752"
  end

  create_table "course_questions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "question_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id", null: false
    t.index ["course_id"], name: "index_course_questions_on_course_id"
  end

  create_table "course_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.decimal "goal", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_type_id", null: false
    t.bigint "user_id", null: false
    t.string "cover"
    t.index ["course_type_id"], name: "index_courses_on_course_type_id"
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "notification_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "notification_type_id"
    t.boolean "is_read"
    t.bigint "notifier_id"
    t.bigint "notified_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_type_id"], name: "fk_rails_75cdc2096d"
    t.index ["notified_id"], name: "fk_rails_80bc2fa31e"
    t.index ["notifier_id"], name: "fk_rails_7f05a659ce"
  end

  create_table "question_alternatives", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "alternative_text"
    t.boolean "is_right"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_question_id"
    t.index ["course_question_id"], name: "index_question_alternatives_on_course_question_id"
  end

  create_table "system_modules", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_alternatives", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "question_alternative_id"
    t.binary "course_battle_id", limit: 36, null: false
    t.bigint "question_id", null: false
    t.index ["question_alternative_id"], name: "index_user_alternatives_on_question_alternative_id"
    t.index ["question_id"], name: "fk_rails_878e243cba"
    t.index ["user_id", "question_alternative_id", "course_battle_id"], name: "unique_user_alternattive_index_by_battle", unique: true
    t.index ["user_id"], name: "index_user_alternatives_on_user_id"
  end

  create_table "user_friends", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id1"
    t.bigint "user_id2"
    t.column "status", "enum('accepted','rejected','pending')", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id1", "user_id2"], name: "index_user_friends_on_user_id1_and_user_id2", unique: true
    t.index ["user_id2"], name: "fk_rails_b2454fd8ba"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "username"
    t.datetime "created_at", default: -> { "current_timestamp(6)" }, null: false
    t.datetime "updated_at", default: -> { "current_timestamp(6)" }, null: false
    t.string "password_digest"
    t.column "level", "enum('user','admin')", default: "user"
    t.string "avatar"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "course_battle_messages", "course_battles", on_delete: :cascade
  add_foreign_key "course_battle_messages", "users"
  add_foreign_key "course_battle_users", "course_battles"
  add_foreign_key "course_battle_users", "users"
  add_foreign_key "course_battles", "courses"
  add_foreign_key "course_questions", "courses"
  add_foreign_key "course_questions", "courses", on_delete: :cascade
  add_foreign_key "courses", "course_types"
  add_foreign_key "courses", "users"
  add_foreign_key "notifications", "notification_types"
  add_foreign_key "notifications", "users", column: "notified_id"
  add_foreign_key "notifications", "users", column: "notifier_id"
  add_foreign_key "question_alternatives", "course_questions"
  add_foreign_key "question_alternatives", "course_questions", on_delete: :cascade
  add_foreign_key "user_alternatives", "course_questions", column: "question_id"
  add_foreign_key "user_alternatives", "question_alternatives", on_delete: :cascade
  add_foreign_key "user_alternatives", "users"
  add_foreign_key "user_friends", "users", column: "user_id1"
  add_foreign_key "user_friends", "users", column: "user_id2"
end
