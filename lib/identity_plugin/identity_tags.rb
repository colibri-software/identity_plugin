module IdentityPlugin
  module IdentityPluginTagHelper
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
    end
  end

  class LoginTag < Liquid::Tag
    include IdentityPluginTagHelper
    def render(context)
      super
      @plugin_obj.helper.do_login(@plugin_obj.path, @plugin_obj.controller)
    end
  end

  class LogoutTag < Liquid::Tag
    include IdentityPluginTagHelper
    def render(context)
      super
      @plugin_obj.helper.do_logout(@plugin_obj.path, @plugin_obj.controller)
    end
  end

  class SignupTag < Liquid::Tag
    include IdentityPluginTagHelper
    def render(context)
      super
      @plugin_obj.helper.do_signup(@plugin_obj.path, @plugin_obj.controller)
    end
  end
end
