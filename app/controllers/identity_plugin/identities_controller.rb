require_dependency "identity_plugin/application_controller"

module IdentityPlugin
  class IdentitiesController < ApplicationController
    def new
      @identity = env['omniauth.identity']
      session[:id_reg] = @identity
      redirect_to Engine.plugin_config[:sign_up_url] unless session[:from_engine]
    end
  end
end
