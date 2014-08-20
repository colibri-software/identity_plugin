require 'spec_helper'

module IdentityPlugin
  describe Engine do
    it "should have a config hash" do
      Engine.plugin_config.should be_a(ConfigObject)
      hash = {a: :a, b: :b}
      Engine.plugin_config = hash
      Engine.plugin_config[:a].should eq :a
      Engine.plugin_config[:b].should eq :b
    end
    it "should provide default config values" do
      Engine.plugin_config.keys.count.should be > 2
    end
  end
end
