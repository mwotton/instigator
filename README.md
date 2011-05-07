Instigator is a template for Haskell projects, intended to make it
easier to start a project with all of the goodies like testing, github
repo and optionally Jenkins integration set up.

It is not going to be particularly configurable with respect to the source control
or continuous integraiton: if you don't like the
way a particular thing works, fork the project and change it.

What _can_ be added easily is support for different kinds of project.
Currently there is a Haskell template suitable for building Haskell libraries,
and a Sinatra template suitable for deploying to Heroke.

Getting started:

  bundle
  # only needs to be done once per machine - substitue your CI server here.
  jenkins nodes --host ci.shimweasel.com --port 80
  git config --global github.token YOURTOKEN 
  git config --global github.user YOURLOGIN
  git config --global jenkins.user YOURJENKINSUSER
  git config --global jenkins.password YOURJENKINSPASSWORD


  # actually using the app
  instigate MYAPPNAME --project_type=haskell --lib # project_type does default to haskell
  # or a sinatra project on heroku
  instigate MYAPPNAME --project_type=sinatra


