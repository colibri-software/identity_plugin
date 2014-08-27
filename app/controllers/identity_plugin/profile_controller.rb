require_dependency "identity_plugin/application_controller"

 module IdentityPlugin
   class ProfileController < ApplicationController
     def update
       @user = User.find(params[:id])
       @user.update_profile(params[:user])
       if @user.save
         flash[:notice] = "Profile Updated"
       end
       redirect_to Config.hash[:after_profile_update]
     end
   end
 end
