module IdentityPlugin
  module IdentityHelper
    def do_login(path, controller)
      controller.session[:id_reg] = nil
      if current_user(controller)
        controller.flash[:info] = 'Already signed in!'
      else
        controller.session[:identity_return_to] = controller.request.referer
        controller.render_cell 'identity_plugin/sessions', :new, stem: path
      end
    end

    def do_logout(path, controller)
      msg = Engine.config_or_default('sign_out_msg')
      controller.session[:id_reg] = nil
      if controller.session[:user_id]
        controller.session[:user_id] = nil
        controller.flash[:notice] = msg
      else
        controller.flash[:info] = 'Already logged out!'
      end
      controller.redirect_to :back
    end

    def do_signup(path, controller)
      if current_user(controller)
        controller.flash[:info] = 'Already signed in!'
      else
        controller.render_cell 'identity_plugin/identities', :new,
          stem: path, identity: controller.session[:id_reg]
      end
    end

    def current_user(controller)
      if controller.session[:user_id]
        @current_user ||= User.find(controller.session[:user_id])
      end
    end
  end
end
