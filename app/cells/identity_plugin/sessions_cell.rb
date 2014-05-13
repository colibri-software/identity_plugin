module IdentityPlugin
  class SessionsCell < Cell::Rails
    def new(args)
      @form_path = args[:stem] + 'auth/identity/callback'
      render
    end
  end
end
