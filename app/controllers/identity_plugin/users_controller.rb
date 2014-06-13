require_dependency "identity_plugin/application_controller"

module IdentityPlugin
  class UsersController < ApplicationController
    include IdentityHelper
    # GET /users
    # GET /users.json
    def index
      @users = User.order_by(name: :asc)
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    end
    def new
      @options = {
        name_width: '24',
        email_width: '24',
        password_width: '24',
        password_confirm_width: '24',
        submit_width: '24'
      }
      session['identity_return_to'] = users_path
    end
    # GET /users/1
    # GET /users/1.json
    # GET /users/1/edit
    def edit
      @user = User.find(params[:id])
    end
    # POST /users
    # POST /users.json
    # PUT /users/1
    # PUT /users/1.json
    def update
      @user = User.find(params[:id])
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to edit_user_path(@user), notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
    # DELETE /users/1
    # DELETE /users/1.json
    def destroy
      @user = User.find(params[:id])
      @ident = Identity.find(@user.uid)
      @user.destroy
      @ident.destroy
      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    end
  end
end
