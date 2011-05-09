$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'instigator/util'
require 'git_config'
require 'thor'

# TODO abstract out the heroku stuff
class Rails < Thor
  include GitConfig
  include Thor::Actions
  
  argument :name

  def self.source_root
    File.join(File.dirname(__FILE__), '..', 'templates', 'rails')
  end

  desc "preflight", "Check for preconditions"
  def preflight
    # bit rough and ready, but no heroku api for querying
    # app namespace
    abort "#{name} is already taken on heroku" unless
      HTTParty.get("http://#{name}.heroku.com").code == 404

    # these will abort anyway.
    author && email
  end
  
  desc "setup", "set up a rails-on-heroku project"
  def setup

    guarded "git clone git://github.com/mwotton/railstemplate.git #{name}"
    guarded "rm #{name}/config/database.yml"
    template "database_yml.tt", "#{name}/config/database.yml"
    Dir.chdir name do
      system "git remote rm origin 2>/dev/null >/dev/null" # hide the evidence
      guarded "heroku create #{name}"
      File.open("runtests.sh", "w") do |f|
        f.write "bundle exec rspec spec"
      end
    end
  end
  
end

