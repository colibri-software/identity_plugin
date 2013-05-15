IdentityEngine::Engine.config.middleware.use OmniAuth::Builder do
  provider :identity, model: IdentityEngine::Identity,
    on_failed_registration: lambda { |env|
    IdentityEngine::IdentitiesController.action(:new).call(env)
  }
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
