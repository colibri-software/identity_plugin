require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'
require 'identity_plugin/rails_engine'
require 'identity_plugin/identity_drop'
require 'identity_plugin/identity_tags'

module IdentityPlugin
  class PluginHelper
  end

  class IdentityPlugin
    include Locomotive::Plugin

    before_rack_app_request :set_config

    def self.rack_app
      IdentityEngine::Engine
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
      if !@helper
        @helper = PluginHelper.new
        @helper.instance_eval { extend IdentityEngine::IdentityHelper }
      end
      return @helper
    end

    def path
      '/locomotive/plugins/identity_plugin/'
    end

    ##############
    # basic drops
    ##############
    def user
      current_user ? current_user.name : 'Guest'
    end

    def user_id
      current_user ? current_user.id.to_s : nil
    end

    def is_signed_in
      current_user != nil
    end

    def flash 
      render_flash_messages
    end

    private
    def current_user
      helper.current_user(controller)
    end

    def render_flash_messages
      ret = ''
      [:alert, :error, :info, :notice, :success, :warning].each do |type|
        ret << "<p class='flash_#{type}'>#{@controller.flash[type]}</p>" if @controller.flash[type]
      end
      ret
    end

    def set_config
      mounted_rack_app.config_hash = config
    end
  end
end
