Rails.application.routes.draw do
  root :to => "home#index"
  match "login"  => "test#login",   :as => "login"
  match "logout" => "test#logout",  :as => "logout"
  match "signup" => "test#signup",  :as => "signup"
  mount Engine => "/"
end
