# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_voip_session',
  :secret      => 'd1bfcd85ded3953f42501c8fb7b6d2ab6eea012947b7271dd2b09aa270921c20671b5f321e3c10266228b9ddfa7d79e604a4b8abfcc0e03fe0cf409c8923802c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
