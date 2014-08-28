require 'spec_helper'

module IdentityPlugin
  describe User do
    describe 'existing user with identity' do
      before :each do
        @identity = FactoryGirl.create(:identity)
        @user = FactoryGirl.create(:user, uid: @identity.uid)
      end
      it 'should have an identity' do
        @user.identity.should eq @identity
      end
      it "should get the email from the identity" do
        @user.email.should eq @identity.email
      end
      it "should set the email in the identity" do
        new_email = "other.email@example.com"
        @user.email = new_email
        @user.save
        @identity.reload.email.should eq new_email
      end
      it "should set the name in the identity" do
        new_name = "Other Name"
        @user.name = new_name
        @user.save
        @identity.reload.name.should eq new_name
      end
      it "should set the password in the identity" do
        current_digest = @identity.password_digest
        new_password = "new_password"
        @user.password = new_password
        @user.password_confirmation = new_password
        @user.save
        @identity.reload.password_digest.should_not eq current_digest
      end
      it "should validate the identity" do
        @user.email = "bad.email.com"
        @user.save.should eq false
        @user.errors.count.should be > 0
      end
      it "should delete the identity when it is destroyed" do
        @user.destroy
        Identity.where(email: @identity.email).count.should eq 0
      end
    end
    describe 'existing user with profile' do
      before :each do
        @user = FactoryGirl.create(:user)
        @profile = FactoryGirl.create(:profile, uid: @user.uid, email: @user.email, name: @user.name, )
        IdentityPlugin.stubs(:profile_model).returns(FakeProfile)
        FakeProfile.stubs(:entries).returns(FakeProfile)
        Config.hash[:profile_model_enabled] = true
      end
      it "should not have a profile is they are disabled" do
        Config.hash[:profile_model_enabled] = false
        @user.profile.should be nil
      end
      it 'should have a profile' do
        @user.profile.should eq @profile
      end
      it "should be able to update its profile" do
        hash = {
          'name' => "New name",
          'email' => "new.email@example.com",
          'password' => "new password",
          'password_confirmation' => "new password",
        }
        @user.update_profile(hash)
        @profile.reload
        @profile.name.should eq "New name"
        @profile.email.should eq "new.email@example.com"
      end
      it "should delete the profile when it is destroyed" do
        uid = @user.uid
        @user.destroy
        FakeProfile.where(uid: uid).count.should eq 0
      end
    end
    describe 'class methods' do
      it "should be able to create a new user" do
        identity = FactoryGirl.create(:identity)
        auth = {
          'provider' => "identity",
          'uid' => identity.id,
          'info' => {
          'name' => identity.name
        }
        }
        expect{User.from_omniauth(auth)}.to change{User.count}.from(0).to(1)
      end
      it "should be abel to retrive an existing user" do
        user = FactoryGirl.create(:user)
        auth = {
          'provider' => "identity",
          'uid' => user.uid,
        }
        expect{User.from_omniauth(auth)}.to change{User.count}.by(0)
        User.from_omniauth(auth).name.should eq user.name
        User.from_omniauth(auth).email.should eq user.email
      end
    end
    describe 'liquid' do
      it "should be able to be converted to liquid" do
        user = FactoryGirl.create(:user)
        user.respond_to?(:to_liquid).should be true
        user.to_liquid.should be_a(::Liquid::Drop)
      end
      it "should have access to the profile as liquid" do
        IdentityPlugin.expects(:profile_model).returns(FakeProfile)
        FakeProfile.expects(:entries).returns(FakeProfile)
        user = FactoryGirl.create(:user)
        profile = FactoryGirl.create(:profile, uid: user.uid, email: user.email, name: user.name)
        user.to_liquid.profile.should eq profile
      end
    end
  end
end
