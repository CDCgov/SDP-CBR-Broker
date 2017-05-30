namespace :accounts do
  desc 'Create a new account and associated queue if it does not exist'
  task :create, [:uid, :queue_name] => :environment do |_t, args|
    acc = Account.create(uid: args.uid,
                         queue_name: args.queue_name,
                         created_at: Time.now,
                         updated_at: Time.now)
    acc.queue
  end
  task :delete, [:uid] => :environment do |_t, args|
    acc = Account.where(uid: args.uid).first
    acc.delete!
  end
end
