Rails.application.routes.draw do

  # You can have the root of your site routed with "root"
  root 'pages#index'
  get '/login', to: 'pages#login'

  # This is where we are redirected if OmniAuth successfully authenticates
  # the user.
  match '/auth/:provider/callback', to: 'pages#callback', via: [:get, :post]
  match '/disconnect', to: 'pages#disconnect', via: [:get]
  match '/.well-known/acme-challenge/LYUENMW3_SAPWV2OMUiL1xoOXkkkuL1WbbQ1mLvSZmE', to: 'config#ssl_key', via: [:get]

  resources :pizzas, only: [:index, :create, :show, :destroy]
  resources :users, only: [:index, :create, :destroy] do
  end

  resources :bases, only: [:index, :create, :update, :destroy]
  

  resource :users do
    post :login, to: 'users#authenticate'
    get '/orders', to: 'users#order'
  end
  resources :admins, only: [:index, :create, :destroy]
  
  resource :config do
    post :end_date, to: 'config#nextEndDate'
    get :end_date, to: 'config#currentEndDate'
  end

  resources :orders, param: :order_id, only: [:index, :create, :destroy, :update] do
    get '/:id', to: 'orders#show'
    put '/cancel', to: 'orders#cancel'
  end
  resource :orders do
    # get :summary, to: 'orders#summary'
    # get :total, to: 'orders#total'
    # get :open_sales, to: 'orders#open_sales'
    # get :unpaid, to: 'orders#unpaid_orders'
  end

end
