require 'uuid'
module Instigator
  class Github
    include Thor::Actions

    def initialize(name, token)
      @name=name
      @token=token

      create_project
    end

    def add_notification(ci)
      # log into ci, make sure BUILDMENOW token (or equivalent
      # randomised thing is set
      @ci.set_token
      set_build_token(@ci.token)
    end

    def create_project
      # log in using token, create new project in github
      
    end

    private
    def set_build_token(ci_token)

    end
  end
end
