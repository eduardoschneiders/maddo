# rubocop:disable Metrics/MethodLength
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
    subscription = find_subscription!(resource['id'])

    case event_type
    when 'BILLING.SUBSCRIPTION.CREATED'
      subscription.create_subscription_payment!
    when 'BILLING.SUBSCRIPTION.ACTIVATED'
      subscription.activate_subscription_payment!
    when 'PAYMENT.SALE.COMPLETED'
      subscription.complete_sale_payment!
    else
      log_error("Event type: #{event_type} not found for subscription id: ##{resource['id']}")
    end

    # subscription.update(
    #   payment_status: event_type,
    #   next_billing_time: params['resource']['billing_info']['next_billing_time']
    # )
    subscription.update(payment_status: event_type)
  end

  def find_subscription!(id)
    Subscription.find_by_paypal_subscription_id!(id)
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

  def log_error(msg)
    Rails.logger.info("WebhookpaypalController(error): #{msg}")
  end
end
# rubocop:enable Metrics/MethodLength
