
require 'rubygems'
require 'bundler/setup'

require 'locomotive_plugins'

require 'identity_plugin/rails_engine'
require 'identity_plugin/identity_drop'

module IdentityPlugin
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

    # drops
    def login_url
      "#{site_path}/login"
    end

    def logout_url
      "#{site_path}/logout"
    end

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
      # @controller.flash.inspect
      render_flash_messages
    end

    private

    def site_path
      '/locomotive/plugins/identity_plugin'
    end

    def current_user
      @current_user ||= IdentityEngine::User.find(@controller.session[:user_id]) if @controller.session[:user_id]
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
