module IdentityPlugin
  class IdentitiesCell < Cell::Rails
    def new(args)
      @identity  = args[:identity]
      @form_path = args[:stem] + 'auth/identity/register'
      @options = args[:options]
      render
    end
  end
end
