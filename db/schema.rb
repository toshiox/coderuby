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

ActiveRecord::Schema[7.1].define(version: 2024_08_09_204010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_contents", id: false, force: :cascade do |t|
    t.integer "id"
    t.integer "articleId"
    t.string "content"
    t.datetime "createdAt"
  end

  create_table "article_images", id: false, force: :cascade do |t|
    t.integer "id"
    t.integer "articleId"
    t.string "imageURL"
    t.integer "typeImage"
    t.datetime "createdAt"
  end

  create_table "article_views", id: false, force: :cascade do |t|
    t.integer "id"
    t.integer "articleId"
    t.string "ipAddress"
    t.datetime "view_date"
  end

  create_table "articles", id: false, force: :cascade do |t|
    t.integer "id"
    t.string "title"
    t.string "subtitle"
    t.string "resume"
    t.string "tags"
    t.string "language"
    t.integer "time_read"
    t.integer "views"
    t.datetime "created_at"
  end

end
