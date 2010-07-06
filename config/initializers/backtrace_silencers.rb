# Be sure to restart your server when you modify this file.

# You can add backtrace silencers for libraries that you're using but don't wish to see in your backtraces.

Rails.backtrace_cleaner.add_silencer { |line| line =~ /actionpack/ }
Rails.backtrace_cleaner.add_silencer { |line| line =~ /active_record/ }
Rails.backtrace_cleaner.add_silencer { |line| line =~ /action_controller/ }
Rails.backtrace_cleaner.add_silencer { |line| line =~ /rack/ }

# You can also remove all the silencers if you're trying do debug a problem that might steem from framework code.
# Rails.backtrace_cleaner.remove_silencers!