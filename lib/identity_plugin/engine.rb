module IdentityPlugin
  class Engine < ::Rails::Engine
    isolate_namespace IdentityPlugin

    def self.config_hash=(hash)
      @config_hash = hash
    end

    def self.config_hash
      @config_hash ||= {}
    end

    def self.config_or_default(key)
      msg = config_hash[key]
      return msg if msg && !msg.empty?

      return 'Signed in!'  if key == 'sign_in_msg'
      return 'Signed out!' if key == 'sign_out_msg'
      return '/login'      if key == 'login_url'
      return '/logout'     if key == 'logout_url'
      return '/signup'     if key == 'sign_up_url'
      return ""            if key == 'groups'
      if key == 'error_msg'
        return 'Authentication failed, please try again!'
      end
    end
  end
end
