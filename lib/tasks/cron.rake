task :cron => :environment do
  puts "Creating bills from feed..."
  Bill.create_from_feed
  puts "done."
  
  puts "Updating bills..."
  Bill.all.each { |b| b.update_me }
  puts "done."
end
