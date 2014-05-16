require_dependency "identity_plugin/application_controller"

module IdentityPlugin
  class SessionsController < ApplicationController
    def create
      auth = request.env["omniauth.auth"]
      user = User.where(:provider => auth["provider"],
                        :uid => auth["uid"]).first || User.create_with_omniauth(auth)
      session[:user_id] = user.id
      session[:id_reg] = nil
      redirect_to Engine.config_or_default('after_login_url'), :notice => sign_in_msg
    end

    def failure
      redirect_to Engine.config_or_default('login_url'),
        flash: {error: 'Invalid user or password.'}
    end

    private
    def sign_in_msg
      Engine.config_or_default('sign_in_msg')
    end

    def error_msg
      Engine.config_or_default('error_msg')
    end
  end
end
