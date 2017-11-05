namespace :notifications do
  desc "Let the admins know about all the new shit this week."
  task :new_stuff_admin, [:since] => :environment do |_t, args|
    args.with_defaults(since: 7)
    since = args[:since].to_i
    AdminMailer.alert_new_stuff(since).deliver_later
  end
end
