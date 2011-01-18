# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110118055803) do

  create_table "authentication_tokens", :id => false, :force => true do |t|
    t.string   "uuid",       :limit => 36
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persist"
  end

  create_table "barcode_lookups", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chambers", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "name"
    t.string  "logo"
  end

  create_table "corporate_audits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "corporation_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corporation_supports", :force => true do |t|
    t.integer  "corporation_id"
    t.integer  "user_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corporations", :force => true do |t|
    t.string   "name"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "social_score"
    t.integer  "participation_rate"
    t.decimal  "revenue",            :precision => 18, :scale => 0
    t.decimal  "profit",             :precision => 18, :scale => 0
    t.string   "corporate_url"
    t.string   "wikipedia_url"
  end

  create_table "government_audits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "government_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "government_supports", :force => true do |t|
    t.integer  "government_id"
    t.integer  "user_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "government_types", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "name"
    t.string  "logo"
  end

  create_table "governments", :force => true do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "active"
    t.string   "political_party"
    t.integer  "state_id"
    t.string   "seat"
    t.integer  "chamber_id"
    t.string   "district"
    t.string   "gender"
    t.string   "phone_number"
    t.string   "website"
    t.string   "wikipedia"
    t.string   "logo"
    t.string   "email"
    t.integer  "government_type_id"
    t.integer  "default_order"
    t.integer  "social_score"
    t.integer  "participation_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "search_text"
  end

  create_table "media_audits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "media_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_supports", :force => true do |t|
    t.integer  "media_id"
    t.integer  "user_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_types", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "name"
    t.integer "level"
    t.integer "display_order"
    t.string  "logo"
  end

  create_table "medias", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "media_type_id"
    t.integer  "social_score"
    t.integer  "participation_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo"
    t.integer  "parent_media_id"
    t.string   "wikipedia"
  end

  create_table "pending_products", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  create_table "product_audits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_scans", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_supports", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "upc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ean"
    t.string   "source"
    t.string   "found"
    t.string   "status"
    t.string   "message"
    t.string   "logo"
    t.integer  "social_score"
    t.integer  "participation_rate"
    t.integer  "pending"
  end

  create_table "states", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "abbreviation"
    t.string  "name"
    t.string  "logo"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "hashed_password"
    t.integer  "birth_year"
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "salt"
    t.string   "zip_code"
  end

  create_table "zips", :force => true do |t|
    t.string  "zip"
    t.integer "state_id"
    t.integer "population"
  end

end
