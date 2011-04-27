require 'net/http'
require 'net/https'
require 'json'

module Git
  
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

  # should possibly be elsewhere?  
  def guarded(task)
    %x{#{task}}.tap { raise "bad exit" if $?.exitstatus!=0 }
  rescue => e
    raise e unless block_given?
    yield e
  end

  
  protected
  def git_attribute(tag, name)
    guarded("git config --global #{tag}") do |error|
      abort "please add your #{name} to ~/.gitconfig with git config --global #{tag} #{name.to_upper}"
    end.chomp
  end
 
end
