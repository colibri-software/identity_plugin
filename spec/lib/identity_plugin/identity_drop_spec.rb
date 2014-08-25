require 'spec_helper'

module IdentityPlugin
  describe IdentityDrop do

    before :each do
      @plugin = IdentityPlugin.new
    end

    describe 'with_user' do
      before :each do
        @user = FactoryGirl.create(:user)
        @plugin.stubs(:current_user).returns(@user)
      end
      it 'should have the user name' do
        content = render_template("{{identity_plugin.user}}")
        content.should eq @user.name
      end
      it 'should have the user email' do
        content = render_template("{{identity_plugin.email}}")
        content.should eq @user.email
      end
      it 'should have the user id' do
        content = render_template("{{identity_plugin.user_id}}")
        content.should eq @user.id.to_s
      end
      it 'should be able to tell you if the user has a role' do
        role = FactoryGirl.create(:role, name: "User")
        @user.add_role(role.name.to_sym)
        content = render_template("{{identity_plugin.has_role_#{role.name}}}")
        content.should eq "true"
        content = render_template("{{identity_plugin.has_role_otherrole}}")
        content.should eq "false"
      end
    end
    describe 'without_user' do
      before :each do
        @plugin.stubs(:current_user).returns(nil)
      end
      it 'should have the user name' do
        content = render_template("{{identity_plugin.user}}")
        content.should eq "Guest"
      end
      it 'should have the user email' do
        content = render_template("{{identity_plugin.email}}")
        content.should eq "guest"
      end
      it 'should have the user id' do
        content = render_template("{{identity_plugin.user_id}}")
        content.should eq ""
      end
      it 'shouldn\'t fail when testing roles' do
        content = render_template("{{identity_plugin.has_role_arole}}")
        content.should eq "false"
      end
    end
    it 'should be able to tell you if someone is logged in' do
      @plugin.stubs(:current_user).returns(nil)
      content = render_template("{% if identity_plugin.is_signed_in %}Signed In{% else %}Not Signed In{% endif %}")
      content.should eq "Not Signed In"
      user = FactoryGirl.create(:user)
      @plugin.stubs(:current_user).returns(user)
      content = render_template("{% if identity_plugin.is_signed_in %}Signed In{% else %}Not Signed In{% endif %}")
      content.should eq "Signed In"
    end
    it 'should provide access to the flash' do
      controller = FakeController.new()
      controller.flash = {error: 'Bad Stuff'}
      context = ::Liquid::Context.new({},
        {'identity_plugin' => @plugin},
        {controller: controller})
      tempalte = "{{identity_plugin.flash.error}}"
      Liquid::Template.parse(tempalte).render(context).should eq "Bad Stuff"
    end

    def render_template(template = '', assigns = {})
      assigns = {
        'identity_plugin' => @plugin
      }.merge(assigns)

      Liquid::Template.parse(template).render!(assigns)
    end
  end
  class FakeController
    def initialize()
      @session = {}
      @flash = {}
    end
    attr_accessor :session, :flash, :request
  end
end
