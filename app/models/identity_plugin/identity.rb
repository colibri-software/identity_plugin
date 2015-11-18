module IdentityPlugin
  class Identity
    include Locomotive::Plugins::Document
    include OmniAuth::Identity::Models::Mongoid

    field :email, type: String
    field :name, type: String
    field :password_digest, type: String

    field :password_reset_token
    field :password_reset_sent_at, type: DateTime

    validates_presence_of :name
    validates_uniqueness_of :email
    validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

    def send_password_reset(base_url)
      generate_token(:password_reset_token)
      self.password_reset_sent_at = Time.zone.now
      save!
      url = password_reset_url(base_url)
      IdentityMailer.password_reset(self, url).deliver
    end

    protected

    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while Identity.where(column => self[column]).any?
    end

    def password_reset_url(base_url)
      uri = URI(base_url)
      if uri.query
        q = CGI::parse(uri.query)
      else
        q = {}
      end
      q[:password_reset_token] = self.password_reset_token
      uri.query = URI.encode_www_form(q)
      uri.to_s
    end
  end
end
