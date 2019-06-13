require "bundler/gem_tasks"
require_relative "./config/environment.rb"

task :default => :spec

task :console do 
  CommandLineInterface.new.run
  Pry.start
end


