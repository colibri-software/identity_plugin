require_dependency "identity_engine/application_controller"
require_dependency 'flash-dance'

module IdentityEngine
  class SessionsController < ApplicationController
    def new
    end

    def create
      auth = request.env["omniauth.auth"]
      user = User.where(:provider => auth["provider"], :auth => auth["uid"]).first || User.create_with_omniauth(auth)
      session[:user_id] = user.id
      redirect_to root_url, :notice => 'Signed in!'
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_url, :notice => 'Signed out!'
    end

    def failure
      redirect_to root_url, :error => 'Authentication failed, please try again.'
    end
  end
end
