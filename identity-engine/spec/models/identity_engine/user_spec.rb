require 'spec_helper'

describe IdentityEngine::User do
  before :each do
    @user = IdentityEngine::User.new
  end

  describe 'when the name has been set' do
    it 'should have a name' do
      @user.name = 'test'
      @user.name.should_not be_blank
    end
  end
end
