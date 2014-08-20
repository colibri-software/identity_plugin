require 'spec_helper'

module IdentityPlugin
  describe Identity do
    it {should validate_presence_of(:name) }
    it {should validate_uniqueness_of(:email) }
    it {should allow_value('user@example.com').for(:email) }
    it {should allow_value('user.name@example.com').for(:email) }
    it {should allow_value('user@domain.example.com').for(:email) }
    it {should_not allow_value('user.example.com').for(:email) }
    it {should_not allow_value('@example.com').for(:email) }
    it {should_not allow_value('*@example.com').for(:email) }
  end
end
