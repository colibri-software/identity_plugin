require_dependency IdentityPlugin::Engine.root.join('app', 'helpers', 'identity_plugin', 'identity_helper').to_s

module IdentityPlugin
  class LoginTag < Liquid::Tag
    include IdentityPlugin::IdentityHelper
    def initialize(tag_name, markup, tokens, context)
      @options = {
        email_width: '24',
        password_width: '24',
        submit_width: '24'
      }
      markup.scan(::Liquid::TagAttributes) { |key, value| @options[key.to_sym] = value.gsub(/"|'/, '') }
      super
    end
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
      do_login(@plugin_obj.path, @plugin_obj.controller, @options)
    end
  end

  class LogoutTag < Liquid::Tag
    include IdentityPlugin::IdentityHelper
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
      do_logout(@plugin_obj.path, @plugin_obj.controller)
    end
  end

  class SignupTag < Liquid::Tag
    include IdentityPlugin::IdentityHelper
    def initialize(tag_name, markup, tokens, context)
      @options = {
        name_width: '24',
        email_width: '24',
        password_width: '24',
        password_confirm_width: '24',
        submit_width: '24'
      }
      markup.scan(::Liquid::TagAttributes) { |key, value| @options[key.to_sym] = value.gsub(/"|'/, '') }
      super
    end
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
      do_signup(@plugin_obj.path, @plugin_obj.controller, @options)
    end
  end
end
