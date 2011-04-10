module Instigator
  class Jenkins
    include Thor::Actions

    def initialize(name, server)
      @name=name
      @server=server

      create_project
    end


    def set_token
      warn 'pending'
    end

    private
    def create_project
      warn "pending"
    end
  end
end
