module IdentityPlugin
  class FakeProfile
    include Locomotive::Plugins::Document
    field :uid
    field :field_1
    field :field_2
  end
end

FactoryGirl.define do
  factory :profile, class: IdentityPlugin::FakeProfile do
    uid { FactoryGirl.create(:user).uid }
    field_1 "Stuff 1"
    field_2 "Stuff 2"
  end
end
