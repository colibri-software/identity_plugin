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
      controller_code do
        if user
          flash[:info] = 'Already signed in!'
        else
          session[:identity_return_to] = request.referer
          render_cell 'identity_engine/sessions', :new,
            :stem => '/locomotive/plugins/identity_plugin/'
        end
      end
    end

    def logout_form
      msg = mounted_rack_app.config_or_default('sign_out_msg', 'Signed out!') 
      controller_code do
        if session[:user_id]
          session[:user_id] = nil
          flash[:notice] = msg
        else
          flash[:info] = 'Already logged out!'
        end
        redirect_to :back
      end
    end

    def sign_up_form
      controller_code do
        render_cell 'identity_engine/identities', :new,
          :stem => '/locomotive/plugins/identity_plugin/'
      end
    end


    private
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

    def controller_code(&block)
      raise "Identity plugin missing controller" if self.controller == nil
      self.controller.instance_eval(&block)
    end
  end
end
