Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "homes#show"
  get 'us', to: 'properties#us'
  resources :users do
    get :switch, on: :member
  end
  resources :properties do
    get :search, on: :collection
    get :mine, on: :collection
    get :suggestions, on: :collection
    get :suggest, on: :collection
    put :set_state, on: :member
    resources :property_assets, controller: 'properties/property_assets' do
      delete :delete_image, on: :member
      delete :delete_video, on: :member
    end
    resources :properties_users, controller: 'properties/properties_users' do
      put :seen, on: :member
      put :unseen, on: :member
    end
  end

  resources :commercial_lands do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :recidential_ploats do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :commercial_buildings do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :houses do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :villas do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :rental_houses do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :rental_offices do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :rental_shopes do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :messages
end
