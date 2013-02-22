
module IdentityPlugin
  class IdentityDrop < ::Liquid::Drop
    delegate :login_url, :logout_url,
             :user, :is_signed_in, :user_id,
             :flash,
      to: :source

    def initialize(source)
      @source = source
    end

    protected
    
    attr_reader :source

  end
end
