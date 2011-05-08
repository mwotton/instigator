$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'instigator/util'
require 'git_config'
require 'thor'

class Sinatra < Thor
  include GitConfig
  include Thor::Actions
  
  argument :name

  desc "preflight", "Check for preconditions"
  def preflight
    # bit rough and ready, but no heroku api for querying
    # app namespace
    abort "#{name} is already taken on heroku" unless
      HTTParty.get("http://#{name}.heroku.com").code == 404

    # these will abort anyway.
    author && email
  end
  
  desc "setup", "set up a sinatra-heroku project"
  def setup

    guarded "git clone git://github.com/mwotton/heroku-sinatra-app.git #{name}"

    Dir.chdir name do 
      guarded "git remote rm origin" # hide the evidence
      guarded "heroku create #{name}"
      File.open("runtests.sh", "w") do |f|
        f.write "bundle exec rspec spec"
      end
    end
  end
  
end

