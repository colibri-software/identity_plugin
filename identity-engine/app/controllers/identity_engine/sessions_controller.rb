require_dependency "identity_engine/application_controller"

module IdentityEngine
  class SessionsController < ApplicationController
    def new
      redirect_to request.referer, :info => 'Already signed in!' if current_user
      session[:identity_return_to] ||= request.referer
      @form_path = root_path + 'auth/identity/callback'
    end

    def create
      auth = request.env["omniauth.auth"]
      user = User.where(:provider => auth["provider"], :auth => auth["uid"]).first || User.create_with_omniauth(auth)
      session[:user_id] = user.id
      session[:identity_return_to] = root_path if session[:identity_return_to] == nil
      redirect_to session[:identity_return_to], :notice => sign_in_msg
    end

    def destroy
      if session[:user_id]
        session[:user_id] = nil
        redirect_to :back, :notice => sign_out_msg
      else
        redirect_to :back, :info => 'Already logged out!'
      end
    end

    def failure
      redirect_to :back, :error => error_msg
    end

    private
    def sign_in_msg
      msg_or_default(Engine.config_hash['sign_in_msg'], 'Signed in!')
    end

    def sign_out_msg
      msg_or_default(Engine.config_hash['sign_out_msg'], 'Signed out!')
    end

    def error_msg
      msg_or_default(Engine.config_hash['error_msg'], 'Authentication failed, please try again!')
    end

    # return the msg if it's not empty otherwise return the default
    def msg_or_default(msg, default)
      msg && !msg.empty? ? msg : default
    end
  end
end
