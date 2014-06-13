module IdentityPlugin
  module IdentityFilters
    def has_role(input)
      @context.registers[:plugin_object].current_user.has_role?(input.to_sym)
    end
  end
end
