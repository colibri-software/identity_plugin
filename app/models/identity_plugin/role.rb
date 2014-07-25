module IdentityPlugin
  class Role
    include Locomotive::Plugins::Document
    has_and_belongs_to_many :users, class_name: "IdentityPlugin::User"
    field :name, :type => String
  end
end
