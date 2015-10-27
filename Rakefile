require File.expand_path('../config/application', __FILE__)
require 'rubocop/rake_task'

Rails.application.load_tasks
RuboCop::RakeTask.new

task default: [:spec, :rubocop]
