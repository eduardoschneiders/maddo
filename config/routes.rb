Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"
  get 'class/index'

  post 'users/:id/create_subscription' => 'users#create_subscription'
  post 'users/:id/create_order' => 'users#create_order'


  get 'checkout/subscription', as: :create_subscription
  get 'checkout/order', as: :create_order
  post 'webhook/paypal/' => 'webhookpaypal#create'
end
