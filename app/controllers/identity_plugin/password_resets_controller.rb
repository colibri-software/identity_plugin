require_dependency "identity_plugin/application_controller"

module IdentityPlugin
  class PasswordResetsController < ApplicationController

    def create
      identity = Identity.where(email: params[:email]).first
      identity.send_password_reset if identity
      # TODO: need to figure out what to do about this
      redirect_to Rails.application.routes.url_helpers.root_url(only_path: true)
    end

    def update
      identity = Identity.where(password_reset_token: params[:id]).first
      if identity.password_reset_sent_at < 2.hours.ago
        # TODO
        redirect_to Rails.application.routes.url_helpers.root_url(only_path: true)
      else
        identity.password = params[:password]
        identity.password_confirmation = params[:password_confirmation]
        identity.save

        # TODO
        redirect_to Rails.application.routes.url_helpers.root_url(only_path: true)
      end
    end

  end
end
