require 'uuid'
require 'net/https'
require 'net/http'
require 'json'
require 'git_config'

class Github < Thor
  include GitConfig
  argument :name

  desc "preflight", "check dependencies"
  def preflight
    abort "you already have a #{name} project on github" unless
      HTTParty.get("http://github.com/#{github_user}/#{name}").code == 404
    github_user
    github_token
  end
  
  desc "delete_project", "erase github project. BE VERY SURE"
  method_option :confirm, :type => :boolean
  def delete_project
    abort "set --confirm to show you really mean it" unless options.confirm?
    res = github_post("/repos/delete/#{github_user}/#{name}", :name => name)
    delete_token = JSON.parse(res.body)['delete_token']
    github_post("/repos/delete/#{github_user}/#{name}", :name => name, :delete_token => delete_token)
  end

  desc "new_project", "new project on github"
  def new_project
    Dir.chdir name do
      guarded "git init"
      guarded "git add ."
      guarded "git commit -m 'initial commit'" do end
      github_post('/repos/create', :name => name)
      guarded "git remote add origin git@github.com:#{github_user}/#{name}"
      announce "new project on github"
    end
  end

  desc "push", "push to github"
  def push
    Dir.chdir(name) { guarded "git push -u origin master" }
  end
  
  
  desc "attach", "sync up github and jenkins"
  method_option :token, :type => :string, :required => true
  def attach
    #ganked from https://gist.github.com/238305
    github_post "/#{github_user}/#{name}/edit/postreceive_urls",
      "urls[]" => "#{jenkins_server}/job/#{name}/build?token=#{options.token}",
    :raw => true
    announce "attached github project to jenkins"
  rescue => e
    puts e
    abort "failed in attach"
  end
  
  no_tasks do
    
    def github_post(path, args)
      # More like NOT::HTTP, amirite?
      # sadly, octokit isn't working right now.
      # @client = Octokit::Client.new(:login => 'pengwynn', :token => 'OU812')    
      options = args.merge(:login => github_user, :token => github_token)
      net = Net::HTTP.new('github.com',443)
      net.use_ssl = true
      url = args.delete(:raw) ? path : "/api/v2/json#{path}"
      req = Net::HTTP::Post.new(url)
      req.set_form_data(options)
      
      response=net.request(req)

      if not [200,302].include? response.code.to_i 
        error = JSON.parse(response.body)['error'] rescue "unparsable"
        raise StandardError, ap(:error => :github, :parsed => error, :code => response.code, :url => url)
      end
      response
    end
    
  end
end

