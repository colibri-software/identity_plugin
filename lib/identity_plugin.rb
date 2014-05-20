require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'
require 'omniauth'
require 'omniauth-identity'
require 'rolify'
require 'foundation-rails'
require 'identity_plugin/engine'
require 'identity_plugin/identity_drop'
require 'identity_plugin/identity_tags'

module IdentityPlugin
  class PluginHelper
    include IdentityHelper
  end

  class IdentityPlugin
    include Locomotive::Plugin

    before_rack_app_request :set_config
    before_rack_app_request :ensure_roles

    def self.rack_app
      Engine
    end

    def config_template_file
      File.join(File.dirname(__FILE__), 'identity_plugin', 'config.html')
    end

    def to_liquid
      @drop ||= IdentityDrop.new(self)
    end

    def self.liquid_tags
      {
        login:  LoginTag,
        logout: LogoutTag,
        signup: SignupTag
      }
    end

    def helper
      @helper ||= PluginHelper.new
      return @helper
    end

    def path
      rack_app_full_path('/')
    end

    ##############
    # basic drops
    ##############

    def current_user
      helper.current_user(controller)
    end

    def flash
      render_flash_messages
    end

    private

    def render_flash_messages
      ret = ''
      [:alert, :error, :info, :notice, :success, :warning].each do |type|
        ret << "<p class='flash_#{type}'>#{@controller.flash[type]}</p>" if @controller.flash[type]
      end
      ret
    end

    def set_config
      Engine.config_hash = config
    end

    def ensure_roles
      roles = Engine.config_or_default("roles").split(/,[  ]*/)
      if roles
        roles.each do |role|
          Role.find_or_create_by(name: role)
        end
      end
    end
  end
end
