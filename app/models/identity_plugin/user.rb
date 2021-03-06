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

    def profile
      if Config.hash[:profile_model_enabled]
        @profile ||= find_or_create_profile
      end
    end

    def to_liquid
      UserDrop.new(self)
    end

    delegate :email, to: :identity

    before_validation :update_email, :update_name, :update_password
    validate :valid_identity
    after_save :save_identity
    after_destroy :cleanup

    def self.from_omniauth(auth)
      where(auth.slice("provider", "uid")).first || create_with_omniauth(auth)
    end

    def self.create_with_omniauth(auth)
      u = create(
        provider: auth["provider"],
        uid: auth["uid"],
        name: auth["info"]["name"]
      )
    end

    def update_profile(hash)
      profile
      self.name = hash.delete('name')
      @email = hash.delete('email')
      @password = hash.delete('password')
      @password_confirmation = hash.delete('password_confirmation')
      hash[Config.hash[:name_field].to_sym] = self.name
      hash[Config.hash[:email_field].to_sym] = @email
      profile.update_attributes(hash) if profile
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

    def cleanup
      profile.destroy if profile
      identity.destroy if identity
    end

    def find_or_create_profile
      IdentityPlugin.profile_model.entries.find_or_create_by({
        Config.hash[:uid_field].to_sym => self.uid,
        Config.hash[:email_field].to_sym => self.email,
        Config.hash[:name_field].to_sym => self.name,
      })
    end
  end

  class UserDrop < ::Liquid::Drop
    def initialize(user)
      @source = user
    end
    def profile
      @source.profile
    end
    delegate :name, :email, :uid, :id, :provider, to: :@source
  end
end
