desc "Loads the app environment"
task :env do
  require "./app"
end

desc "Wipes redis. Use with care!"
task :wipe => [:env] do
  $redis.keys("*").map { |k| $redis.del(k) and puts "Deleted #{k}" }
end