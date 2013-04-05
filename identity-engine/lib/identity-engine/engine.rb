module IdentityEngine
  class Engine < ::Rails::Engine
    isolate_namespace IdentityEngine

    def self.config_hash=(hash)
      @config_hash = hash
    end

    def self.config_hash
      @config_hash ||= {}
    end

    def self.config_or_default(key, default)
      msg = config_hash[key]
      msg && !msg.empty? ? msg : default
    end
  end
end
