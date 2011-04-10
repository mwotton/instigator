require 'active_support/inflector'
module Instigator
  class Skeleton
    include Thor::Actions
    attr_reader :name, :category, :app, :lib
    
    def initialize(name, lib, app, category)
      # use current directory as base + new dir with 'name'
      puts "creating #{Dir.getwd}/#{name}"
      Dir.mkdir name
      Dir.chdir name
      Dir.mkdir "Tests"
      
      @name=name
      @mod = name.camelize
      @category = category
      @lib = lib
      @app = app
    end

    def self.run(*args)
      new(*args).go
    end
    
    def go
      system "cabal init -m -n #{name} -l BSD3 -a Mark Wotton -e mwotton@gmail.com -c #{category} -q"
      # this will always append a 'Library' line - delete it for
      # clarity
      system "sed   -i '$d' #{name}.cabal"

      system "echo and now"
      system "cat #{name}.cabal"
      
      lib_text = (lib && build_libtext) || nil
      app_text = (app && build_executabletext) || nil
      puts "Libtext: #{lib_text}"
      puts "apptext: #{app_text}"
      File.open("#{name}.cabal", "a") {|f| f.write lib_text; f.write app_text}

      File.open("Tests/Test#{mod}.hs", "w") { |f| f.write build_sample_test }
      File.open("#{mod}.hs", "w") {|f| f.write build_module}
      build_watchr

      system "git init; git commit -m 'initial commit';"
      system "cabal install" # sketchy - really just want to get deps
    end

    def build_module
      <<"EOF"
module #{mod} where

foo = 1  
EOF
    end
    def build_sample_test
      <<"EOF"
{-# LANGUAGE ScopedTypeVariables #-}

module T where

import #{mod}
import Test.QuickCheck(property)
test_failing = foo == 1
prop_trivial = property (\\(x::Integer) -> 1+x > x)
EOF
 
    end
    
    # FIXME how do we test binaries? leave for now.    
    def build_executabletext
      <<"EOF"
Executable #{@name}
  Main-is: #{mod}/Main.hs
EOF
      
    end
    
    def build_watchr
      watchr=<<"EOF"
# run tests when they're changed
watch('Tests/.*hs'){|md| system "tbc \#{md[0]}"}
# for the moment, when anything changes, run everything
# we could be more sophisticated, but let's get it running first.
watch('#{mod}/(.*).hs') {|md| system "tbc Tests; hlint . "} 
EOF
      File.open("watchr.rb", "w") {|f| f.write watchr}

    end

    def mod
      @name.camelize
    end
    
    def build_libtext
      # hrm. arguably, there should be only one lib in a cabal
      # package, but let's namespace it anyway.
      <<"EOF"
Library
  -- this is an awful hack, but if we don't specify QC1 here
  -- tbc will grab something else. FIXME PLZ!
  Build-Depends: base, QuickCheck >= 1.1 && <2

-- This isn't actually run: we use TBC.
Executable #{mod}TesterDummy:
  Main-is: Test/#{mod}/Runner.hs
  Build-Depends: TBC, QuickCheck >=1.1 && <2, hlint
  Build-Tools: watchr
EOF
    end
  end
end
