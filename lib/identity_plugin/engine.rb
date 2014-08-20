module IdentityPlugin
  class Engine < ::Rails::Engine
    isolate_namespace IdentityPlugin
    def self.plugin_config=(hash)
      @config_hash = ConfigObject.new(hash)
    end
    def self.plugin_config
      @config_hash ||= ConfigObject.new
    end
    initializer :assets, group: :all do |config|
      Rails.application.config.assets.precompile += %w(
        identity_plugin/application.js
        identity_plugin/application.css
        vendor/modernizr.js
      )
    end
  end
  class ConfigObject < Hash
    def initialize(hash = {})
      defaults = {
        sign_in_msg:          'Signed in!',
        sign_out_msg:         'Signed out!',
        login_url:            '/login',
        after_login_url:      '/',
        logout_url:           '/logout',
        after_logout_url:     '/',
        sign_up_url:          '/signup',
        signed_in_regexp:     'a^',
        roles:                "",
        role_config:          "",
        restricted_page:      '/',
        profile_model:        nil,
        uid_field:            "uid",
        after_profile_update: '/',
      }
      merge!(defaults)
      hash.select! {|k,v| v && (v.class != String || !v.empty?)}
      merge!(hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo})
    end
  end
end
