require 'spec_helper'

module IdentityPlugin
  describe IdentityFilters do
    describe "has role" do
      before :each do
        @filter = FilterStorage.new()
        @filter.context = FakeContext.new({plugin_object: IdentityPlugin.new})
      end
      it "should test if the user has the role" do
        user = FactoryGirl.create(:user)
        @filter.context.registers[:plugin_object].expects(:current_user).returns(user)
        user.expects(:has_role?).with(:test_role)
        @filter.has_role('test_role')
      end
    end
  end

  class FilterStorage
    include IdentityFilters
    attr_accessor :context
  end
  class FakeContext
    def initialize(registers = {})
      @registers = registers
    end
    attr_accessor :registers
  end
end
