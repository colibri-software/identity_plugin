module IdentityPlugin
  class ApplicationController < ActionController::Base
    helper :all

    def signed_in?
      @signed_in = locomotive_account_signed_in?
    end
  end
end
