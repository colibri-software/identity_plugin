require 'spec_helper'

module IdentityPlugin
  describe IdentityHelper do
    before :each do
      @helper = HelperContainer.new()
      @controller = FakeController.new()
      @path = "fake/path"
      @options = {}
    end
    describe 'login' do
      it "should test if there is a user loged in" do
        user = FactoryGirl.create(:user)
        @controller.session = {
          user_id: user.id
        }
        message = "Already signed in!"
        @helper.do_login(@path, @controller, @options).should eq "<p>#{message}</p>"
        @controller.flash[:info].should eq message
      end
      it "render sessions#new cell if no current_user" do
        @controller.expects(:render_cell).with(
          'identity_plugin/sessions',
          :new,
          {stem: @path, options: @options},
          @controller
        ).returns("Called")
        @helper.do_login(@path, @controller, @options).should eq "Called"
      end
    end
    describe 'logout' do
      it "should log the current user out" do
        @controller.session = {
          user_id: "current_id"
        }
        @controller.expects(:redirect_to).with("/")
        @helper.do_logout(@controller)
        @controller.session[:user_id].should eq nil
      end
      it "should notify if no user signed in" do
        @controller.expects(:redirect_to).with("/")
        @helper.do_logout(@controller)
        @controller.flash[:info].should eq "Already logged out!"
      end
    end
    describe 'signup' do
      it "should test if there is a user loged in" do
        user = FactoryGirl.create(:user)
        @controller.session = {
          user_id: user.id
        }
        message = "Already signed in!"
        @helper.do_signup(@path, @controller, @options).should eq "<p>#{message}</p>"
        @controller.flash[:info].should eq message
      end
      it "render identities#new cell if no current_user" do
        @controller.expects(:render_cell).with(
          'identity_plugin/identities',
          :new,
          {stem: @path, identity: nil, options: @options},
        ).returns("Called")
        @helper.do_signup(@path, @controller, @options).should eq "Called"
      end

    end
    describe 'current_user' do
      it "should return a user" do
        user = FactoryGirl.create(:user)
        @controller.session = {
          user_id: user.id
        }
        @helper.current_user(@controller).should eq user
      end
      it "should not fail if the user is missing" do
        user = FactoryGirl.create(:user)
        @controller.session = {
          user_id: user.id
        }
        user.delete
        @helper.current_user(@controller).should eq nil
      end
    end
  end

  class FakeController
    def initialize()
      @session = {}
      @flash = {}
    end
    attr_accessor :session, :flash
  end
  class HelperContainer
    include IdentityHelper
  end
end
