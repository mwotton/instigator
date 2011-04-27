# must be a nicer way of doing this
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'instigator'

class App < Thor
  desc "setup", "create a new app"
  argument :name # don't need it here, but still...
  method_option :project_type, :type => :string, :default => "haskell"
  def setup
    invoke "app:mkdir"
    invoke "#{options.project_type}:setup", [name]
    puts "Starting github"
    invoke "github:new_project"
    invoke "jenkins:new_project"
    invoke "github:add_jenkins"
  end

  desc "mkdir", "create initial dir"
  def mkdir
    puts "creating #{Dir.getwd}/#{name}"
    Dir.mkdir name rescue abort "directory already exists!"
    Dir.chdir name
  end
end

      
#       # set up github project
#       @github = Instigator::Github.new name, options.github_token
      
#       if options.ci_server.nil?
#         warn "no CI server specified (--ci_server)"
#       else
#         # set up CI: hardcode auth for now
#         @ci = Instigator::Jenkins.new name, options.ci_server
#         # set up github build notification
#         @github.add_notification @ci
#       end
#     end
#   end
# end
