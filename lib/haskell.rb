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

  desc "setup", "set up a haskell project"
  def setup
    invoke :mkdir
    Dir.in_dir name do
      invoke :skeleton
      invoke :cabal_dev
    end
  end
  
  desc "mkdir","create the directory"

  def mkdir
    puts "creating #{Dir.getwd}/#{name}"
    Dir.mkdir name rescue abort "directory already exists!"
    Dir.mkdir "#{name}/Tests"
  end

  desc "skeleton", "set up a skeleton haskell project"
  #  method_option :name, :option => :required, :type=>:string
  method_option :category, :option => :required, :type => :string
  method_option :lib, :default => true, :type => :boolean
  method_options :app => false, :type => :boolean  
  def skeleton
    @mod = name.camelize
    system "cabal init -m -n #{name} -l BSD3 -a Mark Wotton -e mwotton@gmail.com -c #{options.category} -q"
    system "rm #{name}.cabal"
    # overwrite the cabal file
    template 'cabal.tt', "#{name}.cabal"
    template 'test.tt', "Tests/Test#{@mod}.hs"
    template 'module.tt', "src/#{@mod}.hs"
    template 'main.tt',   "src/Main.hs" if options.app?
    template 'watchr.tt', "watchr.rb"
    template 'README.tt', "README.md"
  end

  desc "cabal_dev", "ensure cabal-dev is present"
  def cabal_dev
    ["cabal-dev", "happy"].each do |prereq|
      guarded "[ -x `which #{prereq}` ] || cabal install #{prereq}" or raise "#{prereq} not installed"
    end

    # system "cabal-dev install-deps"
    guarded "cabal install -v"
  end
  
end

