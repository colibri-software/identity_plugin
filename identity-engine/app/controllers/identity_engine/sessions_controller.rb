require_dependency "identity_engine/application_controller"
require_dependency 'flash-dance'

module IdentityEngine
  class SessionsController < ApplicationController
    def new
      session[:identity_return_to] ||= request.referer
    end

    def create
      auth = request.env["omniauth.auth"]
      user = User.where(:provider => auth["provider"], :auth => auth["uid"]).first || User.create_with_omniauth(auth)
      session[:user_id] = user.id
      redirect_to session[:identity_return_to], :notice => 'Signed in!'
    end

    def destroy
      session[:user_id] = nil
      redirect_to :back, :notice => 'Signed out!'
    end

    def failure
      redirect_to :back, :error => 'Authentication failed, please try again.'
    end
  end
end
