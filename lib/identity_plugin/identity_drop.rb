
module IdentityPlugin
  class IdentityDrop < ::Liquid::Drop
    delegate :login_url, :logout_url, :sign_up_url,
             :user, :is_signed_in, :user_id,
             :flash,
             :login_form, :logout_form, :signup_form,
      to: :source

    def initialize(source)
      @source = source
    end

    protected
    
    attr_reader :source
  end
end
