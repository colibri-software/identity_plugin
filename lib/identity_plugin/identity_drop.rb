
module IdentityPlugin
  class IdentityDrop < ::Liquid::Drop
    delegate :current_user, to: :source

    def initialize(source)
      @source = source
      urls = [:login_url, :logout_url, :sign_up_url]
      urls.each do |name|
        self.class.send(:define_method, name) do
          source.mounted_rack_app.plugin_config[name]
        end
      end
    end

    def user
      current_user ? current_user.name : 'Guest'
    end

    def email
      current_user ? current_user.email : 'guest'
    end

    def user_id
      current_user ? current_user.id.to_s : nil
    end

    def flash
      @context.registers[:controller].flash.to_hash.stringify_keys
    end

    def is_signed_in
      current_user != nil
    end

    def method_missing(method)
      if method.to_s =~ /^has_role_(.+)$/
        return false unless current_user
        current_user.has_role?($1.to_sym)
      else
        super
      end
    end

    def self.public_method_defined?(meth)
      if meth.to_s =~ /^has_role_.*$/
        true
      else
        super
      end
    end

    protected

    attr_reader :source
  end
end
