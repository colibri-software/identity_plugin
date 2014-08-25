FactoryGirl.define do
  sequence :role_name do |n|
    "Role 1"
  end

  factory :role, class: IdentityPlugin::Role do
    name {generate :role_name}
  end
end
