Rails.application.routes.draw do
  root 'pizzas#index'
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
