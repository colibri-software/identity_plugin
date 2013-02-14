require_dependency "identity_engine/application_controller"
require_dependency 'flash-dance'

module IdentityEngine
  class SessionsController < ApplicationController
    def new
      session[:identity_return_to] ||= request.referer
      redirect_to request.referer, :info => 'Already signed in!' if current_user
    end

    def create
      auth = request.env["omniauth.auth"]
      user = User.where(:provider => auth["provider"], :auth => auth["uid"]).first || User.create_with_omniauth(auth)
      session[:user_id] = user.id
      redirect_to session[:identity_return_to], :notice => msg_config.sign_in_msg
    end

    def destroy
      if session[:user_id]
        session[:user_id] = nil
        redirect_to :back, :notice => msg_config.sign_out_msg
      else
        redirect_to :back, :info => 'Already logged out!'
      end
    end

    def failure
      redirect_to :back, :error => 'Authentication failed, please try again.'
    end

    private
    def msg_config
      @configuration ||= Config.first
    end
  end
end
