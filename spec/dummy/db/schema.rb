ActiveRecord::Schema.define(version: 20170707160629) do

  create_table "users", force: :cascade do |t|
    t.string "uid", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.datetime "last_seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

end
