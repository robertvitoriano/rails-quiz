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

ActiveRecord::Schema[7.0].define(version: 2022_09_20_040933) do
  create_table "course_questions", charset: "latin1", force: :cascade do |t|
    t.string "question_text"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "course_types_id", null: false
    t.index ["course_types_id"], name: "index_courses_on_course_types_id"
  end

  create_table "question_alternatives", charset: "latin1", force: :cascade do |t|
    t.string "alternative_text"
    t.boolean "is_right"
    t.integer "course_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "courses", "course_types", column: "course_types_id"
end
