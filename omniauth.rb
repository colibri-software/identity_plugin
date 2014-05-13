Engine.config.middleware.use OmniAuth::Builder do
  provider :identity, model: Identity,
    on_failed_registration: lambda { |env|
    IdentitiesController.action(:new).call(env)
  }
end

