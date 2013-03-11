IdentityEngine::Engine.routes.draw do

  root :to => "home#index"

  resources :identities
  match "login" => "sessions#new", :as => "login"
  match "logout" => "sessions#destroy", :as => "logout"

  match "/auth/:provider/callback" => "sessions#create", :via => :post
end
