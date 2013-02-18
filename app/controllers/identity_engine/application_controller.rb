module IdentityEngine
  class ApplicationController < ActionController::Base
    helper_method :current_user, :custom_stylesheet

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def custom_stylesheet
      ret = Engine.config_hash['css_file']
      !ret || ret.empty? ? nil : ret
    end
  end
end
