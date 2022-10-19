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

ActiveRecord::Schema[7.0].define(version: 2022_10_19_224449) do
  create_table "course_questions", charset: "latin1", force: :cascade do |t|
    t.string "question_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id", null: false
    t.index ["course_id"], name: "index_course_questions_on_course_id"
  end

  create_table "course_types", charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", charset: "latin1", force: :cascade do |t|
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

  create_table "question_alternatives", charset: "latin1", force: :cascade do |t|
    t.string "alternative_text"
    t.boolean "is_right"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_question_id"
    t.index ["course_question_id"], name: "index_question_alternatives_on_course_question_id"
  end

  create_table "user_alternatives", charset: "latin1", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "question_alternative_id"
    t.index ["question_alternative_id"], name: "index_user_alternatives_on_question_alternative_id"
    t.index ["user_id", "question_alternative_id"], name: "index_user_alternatives_on_user_id_and_question_alternative_id", unique: true
    t.index ["user_id"], name: "index_user_alternatives_on_user_id"
  end

  create_table "users", charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "course_questions", "courses"
  add_foreign_key "courses", "course_types"
  add_foreign_key "courses", "users"
  add_foreign_key "question_alternatives", "course_questions"
  add_foreign_key "user_alternatives", "question_alternatives"
  add_foreign_key "user_alternatives", "users"
end
