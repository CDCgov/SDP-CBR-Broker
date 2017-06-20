# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
if Rails.env != 'production'
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  task default: [:create_reports_dir, :rubocop, 'brakeman:run', 'bundle_audit:run']
end

task :create_reports_dir do
  FileUtils.mkdir('./reports') unless Dir.exist?('./reports')
end

Rails.application.load_tasks
