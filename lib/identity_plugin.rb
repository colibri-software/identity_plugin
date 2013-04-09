require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'
require 'identity_plugin/rails_engine'
require 'identity_plugin/identity_drop'

module IdentityPlugin
  class IdentityPlugin
    include Locomotive::Plugin

    ########
    # setup
    ########
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


    ############
    # url drops
    ############
    def login_url
      mounted_rack_app.config_or_default('login_url', '/login')
    end

    def logout_url
      mounted_rack_app.config_or_default('logout_url', '/logout')
    end

    def sign_up_url
      mounted_rack_app.config_or_default('sign_up_url', '/signup')
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


    #############
    # form drops
    #############
    def login_form
      user = current_user
      controller_code { do_login('/locomotive/plugins/identity_plugin/', user) }
    end

    def logout_form
      controller_code { do_logout('/locomotive/plugins/identity_plugin/') }
    end

    def sign_up_form
      controller_code { do_signup('/locomotive/plugins/identity_plugin/') } 
    end


    private
    def current_user
      controller_code { current_user }
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

    def controller_code(&block)
      raise "Identity plugin missing controller" if self.controller == nil
      self.controller.instance_eval do
        if !self.is_a? IdentityEngine::IdentityHelper
          extend IdentityEngine::IdentityHelper
        end
      end
      self.controller.instance_eval(&block)
    end
  end
end
