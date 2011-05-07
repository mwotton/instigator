require 'net/http'
require 'net/https'
require 'json'

module GitConfig
  
  def email
    git_attribute 'user.email', 'email'
  end

  def author
    git_attribute 'user.name', 'author'
  end

  def github_token
    git_attribute 'github.token', 'token'
  end

  def github_user
    git_attribute 'github.user', 'username'
  end

  def jenkins_server
    git_attribute 'jenkins.server', 'server'
  end

  def jenkins_user
    git_attribute 'jenkins.user', 'user'
  end

  def jenkins_password
    git_attribute 'jenkins.password', 'password'
  end
  
  protected
  def git_attribute(tag, name)
    guarded("git config --global #{tag}") do |error|
      abort "please add your #{name} to ~/.gitconfig with\n   git config --global #{tag} #{name.upcase}"
    end.chomp
  end
 
end
