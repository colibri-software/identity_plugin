class ApplicationController < ActionController::Base
  protect_from_forgery
  include IdentityEngine::IdentityHelper
  helper_method :current_user
end
