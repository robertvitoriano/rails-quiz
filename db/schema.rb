ActiveRecord::Schema[7.0].define(version: 2022_09_21_104139) do
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
end
