# must be a nicer way of doing this
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'instigator'

class App < Thor
  desc "new", "create a new app"
  argument :name # don't need it here, but still...
  method_option :project_type, :type => :string, :default => "haskell"
  def setup
    invoke "app:mkdir"
    invoke "#{options.project_type}:setup", [name]
    puts "Starting github"
    invoke "github:new_project"
    invoke "jenkins:new_project"
  end

  desc "mkdir", "create initial dir"
  def mkdir
    puts "creating #{Dir.getwd}/#{name}"
    Dir.mkdir name rescue abort "directory already exists!"
    Dir.chdir name
  end
end


