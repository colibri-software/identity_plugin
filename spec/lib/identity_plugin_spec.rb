require 'spec_helper'

module IdentityPlugin
  describe IdentityPlugin do
    it "should provide an Engine" do
      IdentityPlugin.rack_app.should eq Engine
    end
    it "should provide a config template" do
      IdentityPlugin.new().config_template_file.should_not eq nil
    end
    it "should provide a liquid drop" do
      IdentityPlugin.new().to_liquid.should be_a(::Liquid::Drop)
    end
    it "should provide liquid tags" do
      IdentityPlugin.liquid_tags.keys.count.should eq 4
    end
    it "should provide liquid filters" do
      IdentityPlugin.liquid_filters.should_not eq nil
    end
    it "should provide access to a helper" do
      IdentityPlugin.new().helper.respond_to?(:current_user).should eq true
    end
    it "should have a path helper" do
      plugin = IdentityPlugin.new()
      plugin.expects(:rack_app_full_path).with("/")
      plugin.path
    end
    it "should have a current_user helper" do
      user = FactoryGirl.create(:user)
      controller = FakeController.new()
      controller.session = {
        user_id: user.id
      }
      plugin = IdentityPlugin.new()
      plugin.expects(:controller).returns(controller)
      plugin.current_user.should eq user
    end
    it "should provide access to the profiel model" do
      test_obj = TestObject.new()
      Thread.current[:site] = test_obj
      test_obj.expects(:content_types).returns(test_obj)
      test_obj.expects(:where).with(slug: nil).returns(test_obj)
      test_obj.expects(:first)
      IdentityPlugin.profile_model
    end
    it "should set the plugin config" do
      Engine.expects(:plugin_config=).with nil
      plugin = IdentityPlugin.new()
      plugin.stubs(:check_path_restrictions)
      plugin.run_callbacks(:page_render) do
        #fake page render
      end
    end
    describe "roles" do
      it "should add any missing roles" do
        plugin = IdentityPlugin.new()
        plugin.expects(:config).returns({ roles: "a, b" })
        expect{
          plugin.run_callbacks(:rack_app_request) do
            #fake rake_app_request
          end
        }.to change{Role.count}.from(0).to(2)
      end
      it "should remove any extra roles" do
        3.times {FactoryGirl.create(:role)}
        plugin = IdentityPlugin.new()
        plugin.expects(:config).returns({ roles: "a, b" })
        expect{
          plugin.run_callbacks(:rack_app_request) do
            #fake rake_app_request
          end
        }.to change{Role.count}.from(3).to(2)
      end
      it 'should provide the users to js3 context' do
        user = FactoryGirl.create(:user)
        cxt = IdentityPlugin.javascript_context
        cxt.keys.include?(:users).should be true
        cxt[:users].call.count.should eq 1
        cxt[:users].call.first.should eq user
      end
    end
    describe "access restrictions" do
      before :each do
        @user = FactoryGirl.create(:user)
        @role = FactoryGirl.create(:role)
        @user.add_role @role.name.to_sym
        @plugin = IdentityPlugin.new()
        @controller = FakeController.new()
        @request = FakeRequest.new()
        @controller.request = @request
        @plugin.stubs(:controller).returns(@controller)
      end
      it "should restrict access based on signed_in_regexp" do
        @plugin.expects(:config).returns({
          signed_in_regexp: "restricted|noaccess"
        })
        @request.path = "restricted"
        @plugin.expects(:current_user).returns(nil)
        @controller.expects(:redirect_to).with("/")
        @plugin.run_callbacks(:page_render) do
          #fake rake_app_request
        end
        @controller.flash[:error].should eq "You are not signed in."
      end
      it "should allow access based on roles" do
        @plugin.stubs(:current_user).returns(@user)
        @request.path = "group_restricted"
        @plugin.expects(:config).returns({
          role_config: "#{@role.name}: group_restricted"
        })
        @plugin.run_callbacks(:page_render) do
          #fake rake_app_request
        end
        @controller.flash[:error].should_not eq "You do not have the correct role."
      end
      it "should restrict access based on roles" do
        @plugin.stubs(:current_user).returns(@user)
        @request.path = "group_restricted"
        @plugin.expects(:config).returns({
          role_config: "other_role: group_restricted"
        })
        @controller.expects(:redirect_to).with("/")
        @plugin.run_callbacks(:page_render) do
          #fake rake_app_request
        end
        @controller.flash[:error].should eq "You do not have the correct role."
      end
      it "should restrict access unless one rule matches path and role" do
        @plugin.stubs(:current_user).returns(@user)
        @request.path = "group_restricted"
        @plugin.expects(:config).returns({
          role_config: "#{@role.name}: group_restricted; other_role: group_restricted"
        })
        @plugin.run_callbacks(:page_render) do
          #fake rake_app_request
        end
        @controller.flash[:error].should_not eq "You do not have the correct role."
      end
    end
  end

  class TestObject
    def method_missing
      return self
    end
  end
  class FakeController
    def initialize()
      @session = {}
      @flash = {}
    end
    attr_accessor :session, :flash, :request
  end
  class FakeRequest
    attr_accessor :path
  end
end
