class ApplicationController < ActionController::Base
  protect_from_forgery
  include IdentityEngine::IdentityHelper
  helper_method :current_user

  def current_user(*args)
    args && args.size > 0 ? super(args.first) : super(self)
  end
end
