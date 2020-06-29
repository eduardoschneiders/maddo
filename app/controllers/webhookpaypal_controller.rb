class WebhookpaypalController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Rails.logger.info('-' * 50)
    Rails.logger.info(params.inspect)
    Rails.logger.info('-' * 50)

    if params['resource_type'] == 'subscription'
      user = User.find_by_paypal_subscription_id(params['resource']['id'])
      user.update(payment_status: params['event_type'])
    end

    head :created
  end
end
