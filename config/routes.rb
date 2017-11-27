Rails.application.routes.draw do
  devise_for :users


  patch "update", to: "tanks#update"
  resources :tanks

  root :to => 'tanks#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
