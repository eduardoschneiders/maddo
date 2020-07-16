Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'
  get 'class/index'

  post 'users/add_paypal_subscription_id' => 'users#add_paypal_subscription_id'
  post 'users/:id/create_order' => 'users#create_order'

  get 'checkout/build_your_plan', as: :build_your_plan
  post 'checkout/generate_plan', as: :generate_plan
  get 'checkout/confirm_subscription', as: :confirm_subscription
  get 'checkout/order', as: :create_order
  post 'webhook/paypal/' => 'webhookpaypal#create'
end
