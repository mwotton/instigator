# must be a nicer way of doing this
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'instigator'
require 'instigator/skeleton'
require 'instigator/jenkins'
require 'instigator/github'

class App < Thor
  
  desc "new APPNAME", "create a new app named APPNAME"
  method_options :ci_server => :string,
  :github_token => :string,
  :lib => :boolean,
  :app => :boolean,
  :category => :string # would be nicer to have a
  # list of options.

  def new(name)
    # skeleton framework for project
    raise "need a github token to push" unless options.github_token?

    Instigator::Skeleton.run name, options.lib?, options.app?, options.category
    # set up github project
    @github = Instigator::Github.new name, options.github_token

    if options.ci_server.nil?
      warn "no CI server specified"
    else
      # set up CI: hardcode auth for now
      @ci = Instigator::Jenkins.new name, options.ci_server
      # set up github build notification
      @github.add_notification @ci
    end

  end
  
end

