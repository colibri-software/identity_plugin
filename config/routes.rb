IdentityPlugin::Engine.routes.draw do
  match "/auth/:provider/callback" => "sessions#create", :via => :post
  match "/auth/failure" => "sessions#failure"
end
