Instigator is a template for Haskell projects, intended to make it
easier to start a project with all of the goodies like testing, github
repo and optionally Jenkins integration set up.

It is not going to be particularly configurable: if you don't like the
way a particular thing works, fork the project and change it.

Getting started:

  bundle
  # only needs to be done once per machine - substitue your CI server here.
  jenkins nodes --host ci.shimweasel.com --port 80
  git config --global github.token YOURTOKEN d5928451e565509088b5429940ea5b84
  git config --global github.user YOURLOGIN
  git config --global jenkins.user YOURJENKINSUSER
  git config --global jenkins.password YOURJENKINSPASSWORD


  # actually using the app
  instigate MYAPPNAME --project_type=haskell --lib # project_type does default to haskell

this should set a new project up.


