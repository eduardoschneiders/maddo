class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update_paypal_subscription_id]

  def update_paypal_subscription_id
    user = User.find(params[:id])


    Rails.logger.info('-----')
    Rails.logger.info(params.inspect)
    Rails.logger.info('-----')
    user.update(
      paypal_subscription_id: params[:paypal_subscription_id])
  end
end
