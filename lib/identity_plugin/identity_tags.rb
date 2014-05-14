require_dependency IdentityPlugin::Engine.root.join('app', 'helpers', 'identity_plugin', 'identity_helper').to_s

module IdentityPlugin
  class LoginTag < Liquid::Tag
    include IdentityPlugin::IdentityHelper
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
      do_login(@plugin_obj.path, @plugin_obj.controller)
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
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
      do_signup(@plugin_obj.path, @plugin_obj.controller)
    end
  end
end
