module IdentityPlugin
  class PasswordResetCell < Cell::Rails
    def forgot(args, controller)
      render
    end

    def reset(args, controller)
      render
    end
  end
end
