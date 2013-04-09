require_dependency "identity_engine/application_controller"

module IdentityEngine
  class SessionsController < ApplicationController
    def create
      auth = request.env["omniauth.auth"]
      user = User.where(:provider => auth["provider"],
                        :uid => auth["uid"]).first || User.create_with_omniauth(auth)
      session[:user_id] = user.id
      session[:id_reg] = nil
      session[:identity_return_to] ||= main_app.root_path
      redirect_to session[:identity_return_to], :notice => sign_in_msg
    end

    def failure
      redirect_to :back, :error => error_msg
    end

    private
    def sign_in_msg
      Engine.config_or_default('sign_in_msg', 'Signed in!')
    end

    def error_msg
      Engine.config_or_default('error_msg', 'Authentication failed, please try again!')
    end
  end
end
