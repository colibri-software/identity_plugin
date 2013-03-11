module IdentityEngine
  class User
    include Mongoid::Document

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
