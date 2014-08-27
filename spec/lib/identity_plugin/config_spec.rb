require 'spec_helper'

module IdentityPlugin
  describe Config do
    it "should have a config hash" do
      Config.hash.should be_a(ConfigObject)
      hash = {a: :a, b: :b}
      Config.hash = hash
      Config.hash[:a].should eq :a
      Config.hash[:b].should eq :b
    end
    it "should provide default config values" do
      Config.hash.keys.count.should be > 2
    end
  end
end
