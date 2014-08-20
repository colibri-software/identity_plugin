FactoryGirl.define do
  factory :user, class: IdentityPlugin::User do
    provider "identity"
    name "John Doe"
    uid { FactoryGirl.create(:identity).id }
  end
end
