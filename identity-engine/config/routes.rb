IdentityEngine::Engine.routes.draw do
  match "/auth/:provider/callback" => "sessions#create", :via => :post
end
