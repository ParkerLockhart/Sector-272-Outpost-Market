Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'
  resources :users, only: [:create]
  get '/register', to: 'users#new'
  get '/login', to: 'users#login'
  post '/login', to: 'users#auth_user'
  get '/logout', to: 'sessions#destroy'
  get '/auth/google_oauth2/callback', to: 'sessions#create'
  get '/dashboard', to: 'users#show'

  resources :merchants, only: [:show, :new, :create] do
    get '/dashboard', to: 'merchants#show'
    resources :items, except: [:destroy]
    resources :invoices, only: [:index, :show, :update]
    resources :invoice_items, only: [:update]
    resources :discounts
  end

  namespace :admin do
    root to: 'admin#index'
    resources :merchants, only: [:index, :new, :show, :create, :edit, :update]
    resources :invoices, only: [:index, :show, :update]
  end
end
