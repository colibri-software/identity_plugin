module IdentityPlugin
  class User
    include Locomotive::Plugins::Document
    rolify(role_cname: "IdentityPlugin::Role")

    field :provider, :type => String
    field :uid, :type => String
    field :name, :type => String

    attr_writer :email, :password, :password_confirmation

    def identity
      @identity ||= Identity.find(uid)
    end

    delegate :email, to: :identity

    before_validation :update_email, :update_name, :update_password
    validate :valid_identity
    after_save :save_identity

    def self.from_omniauth(auth)
      where(auth.slice("provider", "uid")).first || create_with_omniauth(auth)
    end

    def self.create_with_omniauth(auth)
      u = create(
        provider: auth["provider"],
        uid: auth["uid"],
        name: auth["info"]["name"]
      )
      unless u.valid?
        u.identity.reload
        u.save!
      end
    end

    private

    def update_name
      identity.name = self.name if self.name
    end

    def update_email
      identity.email = @email if @email
    end

    def update_password
      identity.password = @password if @password
      identity.password_confirmation = @password_confirmation if @password_confirmation
    end

    def valid_identity
      unless identity.valid?
        identity.errors.each do |field,message|
          errors.add(field,message)
        end
      end
    end

    def save_identity
      identity.save
    end
  end
end
