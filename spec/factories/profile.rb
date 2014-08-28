module IdentityPlugin
  class FakeProfile
    include Locomotive::Plugins::Document
    field :uid
    field :email
    field :name
  end
end

FactoryGirl.define do
  factory :profile, class: IdentityPlugin::FakeProfile do
    uid { FactoryGirl.create(:user).uid }
    email { FactoryGirl.create(:user).email }
    name { FactoryGirl.create(:user).name }
  end
end
