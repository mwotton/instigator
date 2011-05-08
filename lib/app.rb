# must be a nicer way of doing this
# $LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'github'
require 'jenkins'

class App < Thor
  desc "setup", "create a new app"
  argument :name # don't need it here, but still...
  method_option :project_type, :type => :string, :default => "haskell"
  def setup
    require options.project_type rescue raise "No such project type #{options.project_type}"

    [options.project_type, "github", "jenkins"].each do |task_group|
      # run preflight if it exists
      invoke "#{task_group}:preflight" # rescue puts "no preflight for #{task_group}"
    end
    
    invoke "#{options.project_type}:setup", [name]
    puts "Starting github"
    invoke "github:new_project"
    invoke "jenkins:new_project"
  end

end


