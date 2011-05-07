$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'instigator/util'
require 'git_config'
require 'thor'

class Sinatra < Thor
  include GitConfig
  include Thor::Actions
  
  argument :name
  
  desc "setup", "set up a sinatra-heroku project"
  def setup

    guarded "git clone git://github.com/mwotton/heroku-sinatra-app.git #{name}"
    guarded "ls"
    Dir.in_dir name do 
      guarded "git remote rm origin" # hide the evidence
      guarded "heroku create #{name}"
    end
  end
  
end

