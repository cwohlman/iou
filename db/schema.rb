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

ActiveRecord::Schema[7.0].define(version: 2022_11_17_220833) do
  create_table "actions", force: :cascade do |t|
    t.json "action"
    t.integer "user_id", null: false
    t.integer "deal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deal_id"], name: "index_actions_on_deal_id"
    t.index ["user_id"], name: "index_actions_on_user_id"
  end

  create_table "deals", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parties", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "deal_id", null: false
    t.index ["deal_id"], name: "index_parties_on_deal_id"
    t.index ["user_id"], name: "index_parties_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "fullname"
    t.string "email"
    t.text "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "actions", "deals"
  add_foreign_key "parties", "deals"
end
