require_dependency "identity_plugin/application_controller"

module IdentityPlugin
  class PasswordResetsController < ApplicationController

    def create
      identity = Identity.where(email: params[:email]).first
      identity.send_password_reset(request.referer) if identity

      flash[:notice] = 'Password reset instructions were sent to the email address provided'
      redirect_to Rails.application.routes.url_helpers.root_url(only_path: true)
    end

    def update
      identity = Identity.where(password_reset_token: params[:id]).first

      if identity
        if identity.password_reset_sent_at < 2.hours.ago
          flash[:error] = 'Password reset timed out'
        else
          identity.password = params[:password]
          identity.password_confirmation = params[:password_confirmation]

          if identity.save
            flash[:notice] = 'Password reset successful'
          else
            flash[:error] = 'Password confirmation failed. Please try again'
          end
        end
      else
        flash[:error] = 'Invalid reset token. Please try again'
      end

      redirect_to Rails.application.routes.url_helpers.root_url(only_path: true)
    end

  end
end
