IdentityPlugin::Engine.routes.draw do
  resources :users
  resources :identities

  match "/auth/:provider/callback" => "sessions#create", :via => :post
  match "/auth/failure" => "sessions#failure"
end
