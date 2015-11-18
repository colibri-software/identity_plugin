module IdentityPlugin
  class IdentityMailer < ActionMailer::Base
    def password_reset(identity, url)
      @from = Config.hash[:mail_sender]
      @identity = identity
      @url = url
      mail from: @from, to: identity.email, subject: 'Password Reset'
    end
  end
end
