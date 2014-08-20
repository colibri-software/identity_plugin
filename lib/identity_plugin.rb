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
require 'identity_plugin/identity_filters'

module IdentityPlugin
  class PluginHelper
    include IdentityHelper
  end

  class IdentityPlugin
    include Locomotive::Plugin

    before_rack_app_request :set_config
    before_rack_app_request :ensure_roles
    before_page_render :set_config
    before_page_render :check_path_restrictions

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
        signup: SignupTag,
        profile_form: ProfileForm,
      }
    end

    def self.liquid_filters
      IdentityFilters
    end

    def helper
      @helper ||= PluginHelper.new
      return @helper
    end

    def path
      rack_app_full_path('/')
    end

    def self.profile_model
      Thread.current[:site].content_types.where(slug: Engine.config_or_default('profile_model')).first
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
        Role.each do |role|
          role.destroy unless roles.include?(role.name)
        end
        roles.each do |role|
          Role.find_or_create_by(name: role)
        end
      end
    end

    def check_path_restrictions
      unless current_user
        regexp = Regexp.new(Engine.config_or_default('signed_in_regexp'))
        if self.controller.request.path =~ regexp
          self.controller.flash[:error] = "You are not signed in."
          return self.controller.redirect_to Engine.config_or_default('restricted_page')
        end
      end
      path_match = false
      Engine.config_or_default('role_config').split(';').each do |group|
        name, regexp = group.strip.split(':')
        if self.controller.request.path =~ Regexp.new(regexp.strip)
          path_match = true
          if current_user && current_user.has_role?(name.strip.to_sym)
            return
          end
        end
      end
      if path_match
        self.controller.flash[:error] = "You do not have the correct role."
        return self.controller.redirect_to Engine.config_or_default('restricted_page')
      end
    end
  end
end
