require 'identity_plugin/identity_helper'
module IdentityPlugin
  class LoginTag < Liquid::Tag
    include IdentityHelper
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
      do_login(@plugin_obj.path, @plugin_obj.controller)
    end
  end

  class LogoutTag < Liquid::Tag
    include IdentityHelper
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
      do_logout(@plugin_obj.path, @plugin_obj.controller)
    end
  end

  class SignupTag < Liquid::Tag
    include IdentityHelper
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
      do_signup(@plugin_obj.path, @plugin_obj.controller)
    end
  end
end
