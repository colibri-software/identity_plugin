module IdentityPlugin
  class ResetPassword < Liquid::Tag
    def initialize(tag_name, markup, tokens, context)
      super
    end

    def render(context)
      @plugin_obj = context.registers[:plugin_object]
      @controller = @plugin_obj.controller
      @params = @controller.params

      if @params['password_reset_token']
        render_password_reset(@controller)
      else
        render_password_forgot(@controller)
      end
    end

    protected

    def render_password_reset(controller)
      controller.render_cell 'identity_plugin/password_reset', :reset, {}, controller
    end

    def render_password_forgot(controller)
      controller.render_cell 'identity_plugin/password_reset', :forgot, {}, controller
    end
  end
end
