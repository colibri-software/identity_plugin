module IdentityPlugin
  class Config
    def self.hash=(hash)
      @@config_hash = ConfigObject.new(hash)
    end
    def self.hash
      @@config_hash ||= ConfigObject.new
    end
  end
  class ConfigObject < Hash
    def initialize(hash = {})
      defaults = {
        sign_in_msg:           'Signed in!',
        sign_out_msg:          'Signed out!',
        login_url:             '/login',
        after_login_url:       '/',
        logout_url:            '/logout',
        after_logout_url:      '/',
        sign_up_url:           '/signup',
        signed_in_regexp:      'a^',
        roles:                 "",
        role_config:           "",
        restricted_page:       '/',
        profile_model_enabled: false,
        profile_model:         nil,
        email_field:           "email",
        name_field:            "name",
        uid_field:             "uid",
        after_profile_update:  '/',
      }
      merge!(defaults)
      hash.select! {|k,v| v && (v.class != String || !v.empty?)}
      merge!(hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo})
    end
  end
end
