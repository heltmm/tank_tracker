Rails.application.routes.draw do
  devise_for :users

  get "index", to: "tanks#index"
  patch "update", to: "tanks#update"
  post "new", to: "tanks#new"
  
  root :to => 'tanks#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
