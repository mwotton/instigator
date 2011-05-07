require 'uuid'
require 'httparty'
require 'git_config'
require 'thor'

class Jenkins < Thor
  argument :name
  include GitConfig
  include Thor::Actions
  attr_reader :secret

  desc "preflight", "Check for dependencies"
  def preflight
    jenkins_password && jenkins_user
  end

  
  desc "new_project", "set up new jenkins project"
  def new_project
    @secret = UUID.new.generate
    config = ERB.new(File.read File.join(Jenkins.source_root, 'config_xml.tt'))
    jenkins_post "/createItem/api/xml?name=#{name}", config.result(binding)
    invoke 'github:attach', [name], :token => @secret
  end

  def self.source_root
    File.join(File.dirname(File.expand_path(__FILE__)), '..', 'templates')
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
