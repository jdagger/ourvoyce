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

ActiveRecord::Schema.define(:version => 20110317150152) do

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

  create_table "corporation_rank", :id => false, :force => true do |t|
    t.integer "year"
    t.integer "rank"
    t.string  "company"
    t.string  "revenue"
    t.string  "profit"
    t.integer "id"
  end

  create_table "corporation_supports", :force => true do |t|
    t.integer  "corporation_id"
    t.integer  "user_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "corporation_supports", ["corporation_id", "user_id"], :name => "index_corporation_supports_on_corporation_id_and_user_id", :unique => true
  add_index "corporation_supports", ["corporation_id"], :name => "index_corporation_supports_on_corporation_id"
  add_index "corporation_supports", ["support_type"], :name => "index_corporation_supports_on_support_type"
  add_index "corporation_supports", ["user_id", "corporation_id"], :name => "index_corporation_supports_on_user_id_and_corporation_id"
  add_index "corporation_supports", ["user_id"], :name => "index_corporation_supports_on_user_id"

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
    t.string   "revenue_text"
    t.string   "profit_text"
    t.string   "keywords"
  end

  create_table "current_question_supports", :force => true do |t|
    t.integer  "current_question_id"
    t.integer  "user_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "current_questions", :force => true do |t|
    t.string   "question_text"
    t.string   "question_title"
    t.integer  "active"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "error_logs", :force => true do |t|
    t.text     "message"
    t.string   "ip"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "request"
    t.text     "response"
    t.string   "device_type"
    t.string   "user"
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

  add_index "government_supports", ["government_id", "user_id"], :name => "index_government_supports_on_government_id_and_user_id", :unique => true
  add_index "government_supports", ["government_id"], :name => "index_government_supports_on_government_id"
  add_index "government_supports", ["support_type"], :name => "index_government_supports_on_support_type"
  add_index "government_supports", ["user_id"], :name => "index_government_supports_on_user_id"

  create_table "government_types", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "name"
    t.string  "logo"
    t.integer "social_score"
    t.integer "participation_rate"
    t.integer "display_order"
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
    t.string   "office"
    t.string   "keywords"
    t.string   "data1"
    t.string   "data2"
  end

  create_table "legislative_states", :force => true do |t|
    t.integer "state_id"
    t.integer "social_score"
    t.integer "participation_rate"
  end

  create_table "media_audits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "media_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_states", :force => true do |t|
    t.integer "state_id"
    t.integer "social_score"
    t.integer "participation_rate"
  end

  create_table "media_supports", :force => true do |t|
    t.integer  "media_id"
    t.integer  "user_id"
    t.integer  "support_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media_supports", ["media_id", "user_id"], :name => "index_media_supports_on_media_id_and_user_id", :unique => true
  add_index "media_supports", ["media_id"], :name => "index_media_supports_on_media_id"
  add_index "media_supports", ["support_type"], :name => "index_media_supports_on_support_type"
  add_index "media_supports", ["user_id"], :name => "index_media_supports_on_user_id"

  create_table "media_types", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "name"
    t.integer "level"
    t.integer "display_order"
    t.string  "logo"
    t.integer "social_score"
    t.integer "participation_rate"
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
    t.string   "data1"
    t.string   "data2"
    t.string   "keywords"
  end

  create_table "national_ages", :force => true do |t|
    t.integer "age_1"
    t.integer "age_2"
    t.integer "age_3"
    t.integer "age_4"
    t.integer "age_5"
    t.integer "age_6"
    t.integer "age_7"
    t.integer "age_8"
    t.integer "age_9"
    t.integer "age_10"
    t.integer "age_11"
    t.integer "age_12"
    t.integer "age_13"
    t.integer "age_14"
    t.integer "age_15"
    t.integer "age_16"
    t.integer "age_17"
    t.integer "age_18"
    t.integer "age_19"
    t.integer "age_20"
    t.integer "age_21"
    t.integer "age_22"
    t.integer "age_23"
    t.integer "age_24"
    t.integer "age_25"
    t.integer "age_26"
    t.integer "age_27"
    t.integer "age_28"
    t.integer "age_29"
    t.integer "age_30"
    t.integer "age_31"
    t.integer "age_32"
    t.integer "age_33"
    t.integer "age_34"
    t.integer "age_35"
    t.integer "age_36"
    t.integer "age_37"
    t.integer "age_38"
    t.integer "age_39"
    t.integer "age_40"
    t.integer "age_41"
    t.integer "age_42"
    t.integer "age_43"
    t.integer "age_44"
    t.integer "age_45"
    t.integer "age_46"
    t.integer "age_47"
    t.integer "age_48"
    t.integer "age_49"
    t.integer "age_50"
    t.integer "age_51"
    t.integer "age_52"
    t.integer "age_53"
    t.integer "age_54"
    t.integer "age_55"
    t.integer "age_56"
    t.integer "age_57"
    t.integer "age_58"
    t.integer "age_59"
    t.integer "age_60"
    t.integer "age_61"
    t.integer "age_62"
    t.integer "age_63"
    t.integer "age_64"
    t.integer "age_65"
    t.integer "age_66"
    t.integer "age_67"
    t.integer "age_68"
    t.integer "age_69"
    t.integer "age_70"
    t.integer "age_71"
    t.integer "age_72"
    t.integer "age_73"
    t.integer "age_74"
    t.integer "age_75"
    t.integer "age_76"
    t.integer "age_77"
    t.integer "age_78"
    t.integer "age_79"
    t.integer "age_80"
    t.integer "age_81"
    t.integer "age_82"
    t.integer "age_83"
    t.integer "age_84"
    t.integer "age_85"
    t.integer "age_86"
    t.integer "age_87"
    t.integer "age_88"
    t.integer "age_89"
    t.integer "age_90"
    t.integer "age_91"
    t.integer "age_92"
    t.integer "age_93"
    t.integer "age_94"
    t.integer "age_95"
    t.integer "age_96"
    t.integer "age_97"
    t.integer "age_98"
    t.integer "age_99"
    t.integer "age_100"
  end

  create_table "ourvoyce_state_lookups", :force => true do |t|
    t.integer "state_id"
    t.integer "user_count"
    t.float   "percent_of_population"
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

  add_index "product_supports", ["product_id", "user_id"], :name => "index_product_supports_on_product_id_and_user_id", :unique => true
  add_index "product_supports", ["product_id"], :name => "index_product_supports_on_product_id"
  add_index "product_supports", ["support_type"], :name => "index_product_supports_on_support_type"
  add_index "product_supports", ["user_id"], :name => "index_product_supports_on_user_id"

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
    t.integer  "default_include"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "state_age_lookups", :force => true do |t|
    t.integer "state_id"
    t.integer "age_1"
    t.integer "age_2"
    t.integer "age_3"
    t.integer "age_4"
    t.integer "age_5"
    t.integer "age_6"
    t.integer "age_7"
    t.integer "age_8"
    t.integer "age_9"
    t.integer "age_10"
    t.integer "age_11"
    t.integer "age_12"
    t.integer "age_13"
    t.integer "age_14"
    t.integer "age_15"
    t.integer "age_16"
    t.integer "age_17"
    t.integer "age_18"
    t.integer "age_19"
    t.integer "age_20"
    t.integer "age_21"
    t.integer "age_22"
    t.integer "age_23"
    t.integer "age_24"
    t.integer "age_25"
    t.integer "age_26"
    t.integer "age_27"
    t.integer "age_28"
    t.integer "age_29"
    t.integer "age_30"
    t.integer "age_31"
    t.integer "age_32"
    t.integer "age_33"
    t.integer "age_34"
    t.integer "age_35"
    t.integer "age_36"
    t.integer "age_37"
    t.integer "age_38"
    t.integer "age_39"
    t.integer "age_40"
    t.integer "age_41"
    t.integer "age_42"
    t.integer "age_43"
    t.integer "age_44"
    t.integer "age_45"
    t.integer "age_46"
    t.integer "age_47"
    t.integer "age_48"
    t.integer "age_49"
    t.integer "age_50"
    t.integer "age_51"
    t.integer "age_52"
    t.integer "age_53"
    t.integer "age_54"
    t.integer "age_55"
    t.integer "age_56"
    t.integer "age_57"
    t.integer "age_58"
    t.integer "age_59"
    t.integer "age_60"
    t.integer "age_61"
    t.integer "age_62"
    t.integer "age_63"
    t.integer "age_64"
    t.integer "age_65"
    t.integer "age_66"
    t.integer "age_67"
    t.integer "age_68"
    t.integer "age_69"
    t.integer "age_70"
    t.integer "age_71"
    t.integer "age_72"
    t.integer "age_73"
    t.integer "age_74"
    t.integer "age_75"
    t.integer "age_76"
    t.integer "age_77"
    t.integer "age_78"
    t.integer "age_79"
    t.integer "age_80"
    t.integer "age_81"
    t.integer "age_82"
    t.integer "age_83"
    t.integer "age_84"
    t.integer "age_85"
    t.integer "age_86"
    t.integer "age_87"
    t.integer "age_88"
    t.integer "age_89"
    t.integer "age_90"
    t.integer "age_91"
    t.integer "age_92"
    t.integer "age_93"
    t.integer "age_94"
    t.integer "age_95"
    t.integer "age_96"
    t.integer "age_97"
    t.integer "age_98"
    t.integer "age_99"
    t.integer "age_100"
  end

  create_table "states", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "abbreviation"
    t.string  "name"
    t.string  "logo"
    t.integer "user_count"
    t.integer "population"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.integer  "birth_year"
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "password_salt"
    t.string   "zip_code"
    t.string   "crypted_password"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

  add_index "users", ["birth_year"], :name => "index_users_on_birth_year"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

  create_table "zip_age_lookups", :force => true do |t|
    t.string  "zip"
    t.integer "age_1"
    t.integer "age_2"
    t.integer "age_3"
    t.integer "age_4"
    t.integer "age_5"
    t.integer "age_6"
    t.integer "age_7"
    t.integer "age_8"
    t.integer "age_9"
    t.integer "age_10"
    t.integer "age_11"
    t.integer "age_12"
    t.integer "age_13"
    t.integer "age_14"
    t.integer "age_15"
    t.integer "age_16"
    t.integer "age_17"
    t.integer "age_18"
    t.integer "age_19"
    t.integer "age_20"
    t.integer "age_21"
    t.integer "age_22"
    t.integer "age_23"
    t.integer "age_24"
    t.integer "age_25"
    t.integer "age_26"
    t.integer "age_27"
    t.integer "age_28"
    t.integer "age_29"
    t.integer "age_30"
    t.integer "age_31"
    t.integer "age_32"
    t.integer "age_33"
    t.integer "age_34"
    t.integer "age_35"
    t.integer "age_36"
    t.integer "age_37"
    t.integer "age_38"
    t.integer "age_39"
    t.integer "age_40"
    t.integer "age_41"
    t.integer "age_42"
    t.integer "age_43"
    t.integer "age_44"
    t.integer "age_45"
    t.integer "age_46"
    t.integer "age_47"
    t.integer "age_48"
    t.integer "age_49"
    t.integer "age_50"
    t.integer "age_51"
    t.integer "age_52"
    t.integer "age_53"
    t.integer "age_54"
    t.integer "age_55"
    t.integer "age_56"
    t.integer "age_57"
    t.integer "age_58"
    t.integer "age_59"
    t.integer "age_60"
    t.integer "age_61"
    t.integer "age_62"
    t.integer "age_63"
    t.integer "age_64"
    t.integer "age_65"
    t.integer "age_66"
    t.integer "age_67"
    t.integer "age_68"
    t.integer "age_69"
    t.integer "age_70"
    t.integer "age_71"
    t.integer "age_72"
    t.integer "age_73"
    t.integer "age_74"
    t.integer "age_75"
    t.integer "age_76"
    t.integer "age_77"
    t.integer "age_78"
    t.integer "age_79"
    t.integer "age_80"
    t.integer "age_81"
    t.integer "age_82"
    t.integer "age_83"
    t.integer "age_84"
    t.integer "age_85"
    t.integer "age_86"
    t.integer "age_87"
    t.integer "age_88"
    t.integer "age_89"
    t.integer "age_90"
    t.integer "age_91"
    t.integer "age_92"
    t.integer "age_93"
    t.integer "age_94"
    t.integer "age_95"
    t.integer "age_96"
    t.integer "age_97"
    t.integer "age_98"
    t.integer "age_99"
    t.integer "age_100"
  end

  create_table "zips", :force => true do |t|
    t.string  "zip"
    t.integer "state_id"
    t.integer "population"
    t.string  "latitude"
    t.string  "longitude"
    t.string  "city"
    t.string  "other"
    t.integer "msa"
    t.integer "user_count"
  end

end
