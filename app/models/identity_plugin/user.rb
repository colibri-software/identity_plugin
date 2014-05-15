module IdentityPlugin
  class User
    include Mongoid::Document
    rolify(role_cname: "IdentityPlugin::Role")

    field :provider, :type => String
    field :uid, :type => String
    field :name, :type => String


    def self.create_with_omniauth(auth)
      create! do |user|
        user.provider = auth["provider"]
        user.uid      = auth["uid"]
        user.name     = auth["info"]["name"]
      end
    end
  end
end
