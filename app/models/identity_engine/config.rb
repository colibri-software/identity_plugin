
module IdentityEngine
  class Config
    include Mongoid::Document

    field :sign_in_msg, :type => String
    field :sign_out_msg, :type => String
    field :error_msg, :type => String

    attr_accessible(:sign_in_msg, :sign_out_msg, :error_msg)

    def sign_in_msg
      read_attribute(:sign_in_msg) || 'Signed in!'
    end

    def sign_out_msg
      read_attribute(:sign_out_msg) || 'Signed out!'
    end

    def error_msg
      read_attribute(:error_msg) || 'Authentication failed, please try again.'
    end

    def load_from_hash(config)
      self.sign_in_msg  = config['sign_in_msg']
      self.sign_out_msg = config['sign_out_msg']
      self.error_msg    = config['error_msg']
      self.save!
    end
  end
end
