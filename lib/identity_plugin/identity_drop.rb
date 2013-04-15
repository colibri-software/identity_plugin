
module IdentityPlugin
  class IdentityDrop < ::Liquid::Drop
    delegate :user, :is_signed_in, :user_id, :flash,
      to: :source

    def initialize(source)
      @source = source
      urls = ['login_url', 'logout_url', 'sign_up_url'] 
      urls.each do |name|
        self.class.send(:define_method, name) do
          source.mounted_rack_app.config_or_default(name)
        end
      end
    end

    protected
    
    attr_reader :source
  end
end
