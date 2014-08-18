module IdentityPlugin
  module IdentityHelper
    def do_login(path, controller, options)
      controller.session[:id_reg] = nil
      if current_user(controller)
        controller.flash[:info] = 'Already signed in!'
        "<p>#{controller.flash[:info]}</p>"
      else
        controller.render_cell 'identity_plugin/sessions', :new, stem: path, options: options
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
      controller.redirect_to Engine.config_or_default('after_logout_url')
    end

    def do_signup(path, controller, options)
      if current_user(controller)
        controller.flash[:info] = 'Already signed in!'
        "<p>#{controller.flash[:info]}</p>"
      else
        controller.render_cell 'identity_plugin/identities', :new,
          stem: path, identity: controller.session[:id_reg], options: options
      end
    end

    def current_user(controller)
      if controller.session[:user_id]
        @current_user ||= begin; User.find(controller.session[:user_id]); rescue; nil; end
      end
    end
  end
end
