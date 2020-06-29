Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"
  get 'class/index'

  put 'users/:id/update_paypal_subscription_id' => 'users#update_paypal_subscription_id'
  # put 'users/:id/update_paypal_subscription_id' => 'webhookpaypal#teste'

  get 'checkout/new'
  post 'webhook/paypal/' => 'webhookpaypal#create'
end
