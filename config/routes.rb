Rails.application.routes.draw do
  devise_for :users

  get 'home/index'
  get 'class/index'

  get 'checkout/new'
  post 'webhook/paypal/' => 'webhookpaypal#create'
end
