module IdentityPlugin
  class Engine < ::Rails::Engine
    isolate_namespace IdentityPlugin
    initializer :assets, group: :all do |config|
      Rails.application.config.assets.precompile += %w(
        identity_plugin/application.js
        identity_plugin/application.css
        vendor/modernizr.js
      )
    end
  end
end
