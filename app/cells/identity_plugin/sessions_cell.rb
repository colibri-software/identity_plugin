module IdentityPlugin
  class SessionsCell < Cell::Rails
    def new(args)
      @form_path = args[:stem] + 'auth/identity/callback'
      @options = args[:options]
      render
    end
  end
end
