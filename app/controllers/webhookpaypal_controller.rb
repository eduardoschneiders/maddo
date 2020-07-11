class WebhookpaypalController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Rails.logger.info('-' * 100)
    Rails.logger.info(params.inspect)
    Rails.logger.info('-' * 100)

    if params['resource_type'] == 'checkout-order'
      subscription = Order.find_by_paypal_order_id!(params['resource']['id'])
      subscription.update(payment_status: params['event_type'])
    end

    if params['resource_type'] == 'subscription'
      subscription = Subscription.find_by_paypal_subscription_id!(params['resource']['id'])
      # subscription.update(payment_status: params['event_type'], next_billing_time: params['resource']['billing_info']['next_billing_time'])
      subscription.update(payment_status: params['event_type'])
    end

    head :created
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("User with Paypal subscription id: '#{params['resource']['id']}' not found. Info: #{params.inspect}")

    head :no_content
  end
end
