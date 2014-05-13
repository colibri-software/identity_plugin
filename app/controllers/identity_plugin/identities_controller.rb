require_dependency "identity_plugin/application_controller"

module IdentityPlugin
  class IdentitiesController < ApplicationController
    def new
      session[:id_reg] = env['omniauth.identity']
      redirect_to Engine.config_or_default('sign_up_url')
    end
  end
end
