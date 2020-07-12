class WebhookpaypalController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    log

    handle(params)

    head :created
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error(
      "User with Paypal subscription id: '#{params['resource']['id']}' not found. Info: #{params.inspect}"
    )

    head :no_content
  end

  private

  def handle(params)
    case params['resource_type']
    when 'checkout-order'
      handle_order(resource: params['resource'], event_type: params['event_type'])
    when 'subscription'
      handle_subscription(resource: params['resource'], event_type: params['event_type'])
    end
  end

  def handle_subscription(resource:, event_type:)
    subscription = Subscription.find_by_paypal_subscription_id!(resource['id'])
    # subscription.update(
    #   payment_status: event_type,
    #   next_billing_time: params['resource']['billing_info']['next_billing_time']
    # )
    subscription.update(payment_status: event_type)
  end

  def handle_order(resource:, event_type:)
    subscription = Order.find_by_paypal_order_id!(resource['id'])
    subscription.update(payment_status: event_type)
  end

  def log
    Rails.logger.info('-' * 100)
    Rails.logger.info(params.inspect)
    Rails.logger.info('-' * 100)
  end
end
