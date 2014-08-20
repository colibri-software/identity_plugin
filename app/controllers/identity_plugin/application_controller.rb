module IdentityPlugin
  class ApplicationController < ActionController::Base
    before_filter :set_current_site
    helper :all

    def signed_in?
      @signed_in = locomotive_account_signed_in?
    end

    private

    def fetch_site
      if Locomotive.config.multi_sites?
        @current_site ||= Locomotive::Site.match_domain(request.host).first
      else
        @current_site ||= Locomotive::Site.first
      end
    end

    def set_current_site
      Thread.current[:site] = fetch_site
    end
  end
end
