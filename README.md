Instigator is a template for starting new projects, intended to make it
easier to start a project with all of the goodies like testing, github
repo and Jenkins integration set up.

Currently there are recipes for Sinatra apps running on heroku, and
Haskell apps and libraries.

Getting started:

    bundle
    # only needs to be done once per machine - substitute your CI server here.
    jenkins nodes --host ci.shimweasel.com --port 80
    git config --global github.token YOURTOKEN 
    git config --global github.user YOURLOGIN
    git config --global jenkins.user YOURJENKINSUSER
    git config --global jenkins.password YOURJENKINSPASSWORD


    # a haskell library
    instigate MYAPPNAME --project_type=haskell --lib
    # or a sinatra project on heroku
    instigate MYAPPNAME --project_type=sinatra


TODO

These things are on the agenda when I get more time. If they matter to you, by all means fork and send me a pull request.

  - add local recipes/templates so that the user can have their own templates without forking the repo.
  - cucumber for rails & sinatra
  - proper integration for tbc with the haskell project (bit broken currently)
  - support for gitosis/gitolite rather than github. (If you really want darcs/mercurial/bzr etc, you'll have to do it - it's never going to get onto my priority list.)
  - Template for XCode projects (@whatupdave was going to take a look at this one)
