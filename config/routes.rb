Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "properties#index"
  resources :users do
    get :switch, on: :member
  end
  resources :properties do
    get :search, on: :collection
    get :mine, on: :collection
    get :suggestions, on: :collection
    resources :property_assets, controller: 'properties/property_assets' do
      delete :delete_image, on: :member
      delete :delete_video, on: :member
    end
    resources :properties_users, controller: 'properties/properties_users' do
      put :seen, on: :member
      put :unseen, on: :member
    end
  end

  resources :lands do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :cars do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest_brand, on: :collection
    get :suggest_model, on: :collection
    get :interests, on: :collection 
  end

  resources :houses do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :offices do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end

  resources :servents do
    put :set_state, on: :member
    post :interest, on: :member
    get :suggest, on: :collection
    get :interests, on: :collection 
  end
end
