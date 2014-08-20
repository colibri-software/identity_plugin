FactoryGirl.define do

  sequence :email do |n|
    "john.doe.#{n}@example.com"
  end

  factory :identity, class: IdentityPlugin::Identity do
    email { generate :email }
    name "John Doe"
    password "password"
    password_confirmation "password"
  end
end
