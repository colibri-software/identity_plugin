module IdentityPlugin
  class SessionsCell < Cell::Rails
    def new(args, controller)
      controller.session[:from_engine] = false
      @form_path = args[:stem] + 'auth/identity/callback'
      @options = args[:options] || {}
      render
    end
  end
end
