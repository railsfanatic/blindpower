class RollupOne < ActiveRecord::Migration
  def self.up
    create_table "bills", :force => true do |t|
      t.string   "drumbone_id"
      t.integer  "congress"
      t.string   "bill_type"
      t.integer  "bill_number"
      t.string   "link"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "short_title"
      t.text     "official_title"
      t.text     "summary"
      t.integer  "sponsor_id"
      t.date     "last_action_on"
      t.text     "last_action_text"
      t.date     "enacted_on"
      t.float    "average_rating",     :default => 0.0,  :null => false
      t.datetime "deleted_at"
      t.integer  "deleted_by"
      t.integer  "cosponsors_count",   :default => 0
      t.string   "govtrack_id"
      t.text     "bill_html"
      t.boolean  "dirty",              :default => true, :null => false
      t.integer  "summary_word_count"
      t.integer  "text_word_count"
      t.integer  "blind_count"
      t.integer  "deafblind_count"
      t.string   "state"
      t.date     "text_updated_on"
    end

    add_index "bills", ["drumbone_id"], :name => "index_bills_on_guid"
    add_index "bills", ["govtrack_id"], :name => "index_bills_on_govtrack_id"

    create_table "bills_cosponsors", :id => false, :force => true do |t|
      t.integer "bill_id"
      t.integer "legislator_id"
    end

    create_table "comments", :force => true do |t|
      t.integer  "user_id"
      t.integer  "commentable_id"
      t.string   "commentable_type"
      t.text     "content"
      t.string   "user_ip"
      t.string   "user_agent"
      t.string   "referer"
      t.boolean  "approved",         :default => false, :null => false
      t.integer  "position"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "countries", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "legislators", :force => true do |t|
      t.string   "first_name"
      t.string   "last_name"
      t.integer  "govtrack_id"
      t.string   "bioguide_id"
      t.string   "title"
      t.string   "nickname"
      t.string   "name_suffix"
      t.integer  "district"
      t.string   "state"
      t.string   "party"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "legislators", ["bioguide_id"], :name => "index_legislators_on_bioguide_id"

    create_table "posts", :force => true do |t|
      t.integer  "user_id"
      t.string   "title"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "position"
      t.boolean  "approved",   :default => true, :null => false
      t.string   "user_ip"
      t.string   "user_agent"
      t.string   "referer"
      t.datetime "deleted_at"
      t.integer  "deleted_by"
    end

    create_table "posts_tags", :id => false, :force => true do |t|
      t.integer "post_id"
      t.integer "tag_id"
    end

    create_table "ratings", :force => true do |t|
      t.integer  "rating",        :default => 0
      t.datetime "created_at",                   :null => false
      t.string   "rateable_type",                :null => false
      t.integer  "rateable_id",                  :null => false
      t.integer  "user_id",                      :null => false
    end

    add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

    create_table "states", :force => true do |t|
      t.integer  "country_id"
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "suggestions", :force => true do |t|
      t.integer  "user_id"
      t.string   "kind"
      t.string   "content",    :limit => 140
      t.datetime "deleted_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "suggestions", ["kind"], :name => "index_suggestions_on_kind"

    create_table "tags", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "approved",   :default => false
    end

    create_table "users", :force => true do |t|
      t.string   "username"
      t.string   "email"
      t.string   "crypted_password"
      t.string   "password_salt"
      t.string   "persistence_token"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "admin"
      t.integer  "condition_id"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "address"
      t.string   "city"
      t.string   "zip_code"
      t.string   "phone"
      t.date     "birthdate"
      t.string   "public"
      t.text     "intro"
      t.string   "single_access_token"
      t.string   "perishable_token"
      t.integer  "login_count",         :default => 0
      t.integer  "failed_login_count",  :default => 0
      t.datetime "last_request_at"
      t.datetime "current_login_at"
      t.datetime "last_login_at"
      t.string   "current_login_ip"
      t.string   "last_login_ip"
      t.string   "time_zone"
      t.integer  "country_id"
      t.integer  "state_id"
      t.boolean  "author",              :default => false, :null => false
    end
  end

  def self.down
    drop_table :users
    drop_table :tags
    drop_table :suggestions
    drop_table :states
    drop_table :ratings
    drop_table :posts_tags
    drop_table :posts
    drop_table :legislators
    drop_table :countries
    drop_table :comments
    drop_table :bills_cosponsors
    drop_table :bills
  end
end