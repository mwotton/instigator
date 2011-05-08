require 'active_support/inflector'
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'git_config'
require 'instigator/util'
require 'thor'

class Haskell < Thor
  include GitConfig
  include Thor::Actions

  attr_reader :mod
  argument :name
  
  def self.source_root
    File.join(File.dirname(__FILE__), '..', 'templates')
  end

  desc "preflight", "Check for preconditions"
  def preflight
    author
    email
    abort "#{name} already taken on hackage" unless
      HTTParty.get("http://hackage.haskell.org/package/#{name}").code == 404
    %x{cabal list --simple-output #{name}} == ""
    abort "#{name} directory already exists!" if Dir.exists? name
  end

  desc "setup", "set up a haskell project"
  def setup
    invoke :mkdir
    Dir.chdir name do
      invoke :skeleton
      invoke :cabal_dev
    end
    announce "new haskell project set up"
  end
  
  desc "mkdir","create the directory"

  def mkdir
    puts "creating #{Dir.getwd}/#{name}"
    Dir.mkdir name
    Dir.mkdir "#{name}/Tests"
  end

  desc "skeleton", "set up a skeleton haskell project"
  #  method_option :name, :option => :required, :type=>:string
  method_option :category, :option => :required, :type => :string
  method_option :lib, :default => true, :type => :boolean
  method_options :app => false, :type => :boolean  
  def skeleton
    @mod = name.camelize
    guarded "cabal init -m -n #{name} -l BSD3 -a Mark Wotton -e mwotton@gmail.com -c #{options.category} -q"
    guarded "rm #{name}.cabal" do end
    # overwrite the cabal file
    template 'cabal.tt',  "#{name}/#{name}.cabal"
    template 'test.tt',   "#{name}/Tests/Test#{@mod}.hs"
    template 'module.tt', "#{name}/src/#{@mod}.hs"
    template 'main.tt',   "#{name}/src/Main.hs" if options.app?
    template 'watchr.tt', "#{name}/watchr.rb"
    template 'README.tt', "#{name}/README.md"
    File.open("runtests.sh", "w") do |f|
      f.write "tbc -v Tests"
    end
  end

  desc "cabal_dev", "ensure cabal-dev is present"
  def cabal_dev
    ["cabal-dev", "happy"].each do |prereq|
      guarded "[ -x `which #{prereq}` ]" do
        warn "#{prereq} not installed, attempting..."
        guarded "cabal install #{prereq}" do |err|
          abort "#{prereq} not installable: #{ap err}"
        end
      end
    end

    # system "cabal-dev install-deps"
    guarded "cabal install -v"
  end
  
end

