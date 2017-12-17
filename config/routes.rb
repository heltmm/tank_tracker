Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations"}


  patch "cellar_update", to: "tanks#cellar_update"
  patch "brewer_update", to: "tanks#brewer_update"

  resources :tanks

  root :to => 'tanks#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
