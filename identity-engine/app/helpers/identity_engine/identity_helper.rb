module IdentityEngine
  module IdentityHelper
    def do_login(path)
      session[:id_reg] = nil
      if current_user
        flash[:info] = 'Already signed in!'
      else
        session[:identity_return_to] = request.referer
        render_cell 'identity_engine/sessions', :new, stem: path
      end
    end

    def do_logout(path)
      msg = Engine.config_or_default('sign_out_msg', 'Signed out!')
      session[:id_reg] = nil
      if session[:user_id]
        session[:user_id] = nil
        flash[:notice] = msg
      else
        flash[:info] = 'Already logged out!'
      end
      redirect_to :back
    end

    def do_signup(path)
      if current_user
        flash[:info] = 'Already signed in!'
      else
        render_cell 'identity_engine/identities', :new,
          stem: path, identity: session[:id_reg]
      end
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end
end
