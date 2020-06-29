Rails.application.routes.draw do
  get 'checkout/new'

  post 'webhook/paypal/' => 'webhookpaypal#create'
end
