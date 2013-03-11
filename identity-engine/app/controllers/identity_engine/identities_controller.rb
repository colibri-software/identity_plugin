require_dependency "identity_engine/application_controller"

module IdentityEngine
  class IdentitiesController < ApplicationController
    def new
      @identity = env['omniauth.identity']
      @form_path = root_path + 'auth/identity/register'
    end
  end
end
