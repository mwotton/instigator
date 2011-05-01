require 'uuid'
require 'httparty'
require 'git_config'

class Jenkins < Thor
  argument :name
  include GitConfig
  include Thor::Actions
  attr_reader :secret
  
  desc "new_project", "set up new jenkins project"
  def new_project
    @secret = UUID.new.generate
    template 'config_xml.tt', 'config.xml'
    jenkins_post("/createItem/api/xml?name=#{name}", File.read('config.xml'))
    # post to blah
    File.delete 'config.xml'
    invoke 'github:attach', [name], :token => @secret
  end

  def self.source_root
    File.join(File.dirname(__FILE__), '..', 'templates')
  end
  
  no_tasks do
    def jenkins_post(path,raw)
      HTTParty.post jenkins_server + path,
      :basic_auth => {
        :username => jenkins_user,
        :password => jenkins_password
      },
      :format => :xml,
      :headers => { 'content-type' => 'application/xml' },
      :body => raw
    rescue => e
      abort "couldn't post to jenkins: #{e.inspect}"
    end
     
  end
end
