Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "properties#index"
  resources :users do
    get :switch, on: :member
  end

  resources :properties
end
