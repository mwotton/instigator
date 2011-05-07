$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'git_config'

class Sinatra < Thor
  include GitConfig
  include Thor::Actions
  
  argument :name
  
  desc "setup", "set up a sinatra-heroku project"
  def setup
    guarded "git clone git://github.com/mwotton/heroku-sinatra-app.git #{name}"
    guarded "git remote rm origin" # hide the evidence
    guarded "cd #{name}; heroku create #{name}"
  end
  
end

