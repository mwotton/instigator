require 'uuid'
# require 'octokit'
require 'net/https'
require 'net/http'
require 'json'

class Github < Thor

  desc "delete_project", "erase github project. BE VERY SURE"
  method_option :name, :type => :string, :required => true
  method_option :confirm, :type => :boolean
  def delete_project
    abort "set --confirm to show you really mean it" unless options.confirm?
    res = github_post("/repos/delete/#{github_user}/#{options.name}", :name => options.name)
    delete_token = JSON.parse(res.body)['delete_token']
    github_post("/repos/delete/#{github_user}/#{options.name}", :name => options.name, :delete_token => delete_token)

  end
  
  desc "new_project", "new project on github"
  method_option :name, :type => :string, :required => true
  def new_project
    github_post('/repos/create', :name => options.name)
    guarded "git remote add origin git@github.com:#{github_user}/#{options.name}"
    guarded "git push -u origin master"
  end

  no_tasks do

    def github_post(path, args)
      # More like NOT::HTTP, amirite?
      # sadly, octokit isn't working right now.
      # @client = Octokit::Client.new(:login => 'pengwynn', :token => 'OU812')    
      options = args.merge(:login => github_user, :token => github_token)
      net = Net::HTTP.new('github.com',443)
      net.use_ssl = true
      req = Net::HTTP::Post.new("/api/v2/json#{path}")
      req.set_form_data(options)
      
      response=net.request(req)

      if response.code.to_i != 200
        error = JSON.parse(response.body)['error'] rescue "#{response.code}: #{response.body}"
        abort "github error: #{error}"
      end
      response
    end
    
    def guarded(task)
      %x{#{task}}.tap { raise "bad exit" if $?.exitstatus!=0 }
    rescue => e
      raise e unless block_given?
      yield e
    end

      
    def github_token
      guarded("git config --global github.token") do |error|
        abort "please add your token to ~/.gitconfig with git config --global github.token MYTOKEN"
      end.chomp
    end

    def github_user
      guarded("git config --global github.user") do |error|
        abort "please add your github username to ~/.gitconfig with git config --global github.user MYUSERNAME"
      end.chomp
    end
  
    def add_notification(ci)
      # log into ci, make sure BUILDMENOW token (or equivalent
      # randomised thing is set
    
      @ci.set_token
      set_build_token(@ci.token)
    end
  end


end

