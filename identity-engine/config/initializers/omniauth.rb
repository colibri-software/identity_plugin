IdentityEngine::Engine.config.middleware.use OmniAuth::Builder do
  provider :identity, model: IdentityEngine::Identity,
    on_failed_registration: lambda { |env|
    IdentityEngine::IdentitiesController.action(:new).call(env)
  }
end
