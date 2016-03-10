Rails.application.routes.draw do
  root 'pizzas#index'
  resources :pizzas, only: [:index, :create, :show, :destroy]
  resources :users, only: [:index, :create, :show, :destroy]
  resource :orders do
    get :summary, to: 'orders#summary'
    get :total, to: 'orders#total'
  end
  resources :orders, only: [:index, :create, :show, :destroy]

end
