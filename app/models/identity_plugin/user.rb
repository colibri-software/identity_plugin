module IdentityPlugin
  class User
    include Locomotive::Plugins::Document
    rolify(role_cname: "IdentityPlugin::Role")

    field :provider, :type => String
    field :uid, :type => String
    field :name, :type => String

    def identity
      Identity.find(uid)
    end

    delegate :email, to: :identity

    def self.create_with_omniauth(auth)
      create! do |user|
        user.provider = auth["provider"]
        user.uid      = auth["uid"]
        user.name     = auth["info"]["name"]
      end
    end
  end
end
