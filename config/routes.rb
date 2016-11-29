Rails.application.routes.draw do

  # You can have the root of your site routed with "root"
  root 'pages#index'
  get '/login', to: 'pages#login'

  # This is where we are redirected if OmniAuth successfully authenticates
  # the user.
  match '/auth/:provider/callback', to: 'pages#callback', via: [:get, :post]
  match '/disconnect', to: 'pages#disconnect', via: [:get]

  resources :pizzas, only: [:index, :create, :show, :destroy]
  resources :users, only: [:index, :create, :destroy]
  resource :users do
    post :login, to: 'users#authenticate'
    get '/:id', to: 'users#show', constraint: { id: /\d+/ }
  end
  resources :admins, only: [:index, :create, :destroy]

  resources :orders, only: [:index, :create, :destroy] do
    get '/:id', to: 'orders#show', constraint: { id: /\d+/ }
    post '/pay', to: 'orders#mark_as_paid', constraint: { id: /\d+/ }
  end
  resource :orders do
    get :summary, to: 'orders#summary'
    get :total, to: 'orders#total'
    get :open_sales, to: 'orders#open_sales'
    get :unpaid, to: 'orders#unpaid_orders'
  end
end
