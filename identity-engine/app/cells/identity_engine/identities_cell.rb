module IdentityEngine
  class IdentitiesCell < Cell::Rails
    def new(args)
      @identity  = env['omniauth.identity']
      @form_path = args[:stem] + 'auth/identity/register'
      render
    end
  end
end
