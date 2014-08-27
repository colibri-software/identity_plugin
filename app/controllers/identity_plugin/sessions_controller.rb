require_dependency "identity_plugin/application_controller"

module IdentityPlugin
  class SessionsController < ApplicationController
    def create
      auth = request.env["omniauth.auth"]
      user = User.from_omniauth(auth)
      if session[:from_engine]
        redirect_to users_path
      else
        session[:user_id] = user.id
        redirect_to Config.hash[:after_login_url], :notice => sign_in_msg
      end
    end

    def failure
      redirect_to Config.hash[:login_url],
        flash: {error: 'Invalid user or password.'}
    end

    private
    def sign_in_msg
      Config.hash[:sign_in_msg]
    end

    def error_msg
      Config.hash[:error_msg]
    end
  end
end
