
module Skeleton
class Haskell < Thor

  desc "haskell", "set up a haskell project"
  def haskell
    invoke :mkdir
    invoke :skeleton
    invoke :cabal_dev
  end
  
  desc "mkdir","create the directory"
  method_option :name, :option => :required, :type=>:string 
  def mkdir
    name = options.name
    # use current directory as base + new dir with 'name'
    puts "creating #{Dir.getwd}/#{name}"
    Dir.mkdir name
    Dir.chdir name
    Dir.mkdir "Tests"
  end

  desc "skeleton", "set up a skeleton haskell project"
  method_option :name, :option => :required, :type=>:string
  method_option :category, :option => :required, :type => :string
  method_options :lib => true, :type => :boolean
  method_options :app => false, :type => :boolean  
  def skeleton
    name = options.name
    mod = name.camelize
    
    system "cabal init -m -n #{name} -l BSD3 -a Mark Wotton -e mwotton@gmail.com -c #{options.category} -q"
    # overwrite the cabal file
    template 'cabal.tt', "#{name}.cabal"
    template 'test.tt', "Tests/Test#{mod}.hs"
    template 'module.tt', "#{mod}.hs"
    template 'watchr.tt', "watchr.rb"
  end

  desc "cabal_dev", "ensure cabal-dev is present"
  def cabal_dev
    system "[[ -x `which cabal-dev` ]] || cabal install cabal-dev" or raise "cabal not installed"
    system "cabal-dev install-deps"
  end
  
end
end
