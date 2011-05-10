Instigator is a template for starting new projects, intended to make it
easier to start a project with all of the goodies like testing, github
repo and optionally Jenkins integration set up.

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
