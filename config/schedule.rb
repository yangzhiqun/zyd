# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/tmp/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#

every 7.days do
  rake 'log:clear'
end

#every 20.days do
 # runner 'SpYydjb.auto_commit_overdue'
#end
#
#every 15.minutes do
#  runner '::HeartbeatWorker.perform_async'
#end
#
#every 10.minutes do 
#  runner '::SyncToQzjWorker.perform_async'
#end
