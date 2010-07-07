class RollupThree < ActiveRecord::Migration
  def self.up
    # migration rollup 3
    # from schema.rb version 20100707121702
    create_table "bills", :force => true do |t|
      t.string   "drumbone_id"
      t.integer  "congress"
      t.string   "bill_type"
      t.integer  "bill_number"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "short_title"
      t.text     "official_title"
      t.text     "summary"
      t.integer  "sponsor_id"
      t.date     "last_action_on"
      t.text     "last_action_text"
      t.date     "enacted_on"
      t.float    "average_rating",          :default => 0.0,   :null => false
      t.integer  "cosponsors_count",        :default => 0
      t.string   "govtrack_id"
      t.text     "bill_html"
      t.integer  "summary_word_count"
      t.integer  "text_word_count"
      t.integer  "blind_count"
      t.integer  "deafblind_count"
      t.string   "state"
      t.date     "text_updated_on"
      t.integer  "visually_impaired_count"
      t.boolean  "hidden",                  :default => false
      t.string   "sponsor_name"
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
      t.integer  "position"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "countries", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "code"
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
      t.integer  "sponsored_count",   :default => 0
      t.integer  "cosponsored_count", :default => 0
    end

    add_index "legislators", ["bioguide_id"], :name => "index_legislators_on_bioguide_id"

    create_table "pages", :force => true do |t|
      t.string   "title"
      t.string   "permalink"
      t.text     "content"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "posts", :force => true do |t|
      t.integer  "user_id"
      t.string   "title"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "position"
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
      t.integer  "post_id"
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
      t.boolean  "author",              :default => false,     :null => false
      t.string   "stylesheet",          :default => "default"
    end

    create_table "versions", :force => true do |t|
      t.integer  "versioned_id"
      t.string   "versioned_type"
      t.integer  "user_id"
      t.string   "user_type"
      t.string   "user_name"
      t.text     "changes"
      t.integer  "number"
      t.string   "tag"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
    add_index "versions", ["number"], :name => "index_versions_on_number"
    add_index "versions", ["tag"], :name => "index_versions_on_tag"
    add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
    add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
    add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

    say_with_time "Running rake seed_countries..." do
      Rake::Task["seed_countries"].invoke
    end
    say "DB contains #{Country.count} countries and #{State.count} states.", true
    
    say_with_time "Creating default homepage..." do
      Page.create!(:title => "Homepage", :permalink => "home", :content => "Default home page.")
    end
    
    say_with_time "Creating Bills..." do
      Bill.create_from_feed
    end
  end
  
  def self.down
    drop_table :versions
    drop_table :users
    drop_table :tags
    drop_table :suggestions
    drop_table :states
    drop_table :ratings
    drop_table :posts_tags
    drop_table :posts
    drop_table :pages
    drop_table :legislators
    drop_table :countries
    drop_table :comments
    drop_table :bills_cosponsors
    drop_table :bills
  end
end
