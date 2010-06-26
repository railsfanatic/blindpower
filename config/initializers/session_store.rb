# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_blindpower_session',
  :secret      => '0b54d8ea00c7e1146d5b4806462b8b7e16373eaf63448709c11395a0ed49f6b65dc2498c38bb0349bd941b16baa46a2bff02abe71d668e1997118d3c4c28330c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
