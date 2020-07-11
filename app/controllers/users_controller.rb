class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_subscription, :create_order]

  def create_subscription
    user.subscriptions.create(
      paypal_subscription_id: params[:paypal_subscription_id],
      kind: 'basic_plan',
      payment_status: 'initialized',
      status: 'deactivated',
      expiration_date: nil
    )
  end

  def create_order
    user.orders.create(
      paypal_order_id: params[:paypal_order_id],
      items: ['bola de plastico'],
      payment_status: 'initialized',
      deliver_status: 'pending'
    )
  end

  private

  def user
    User.find(params[:id])
  end
end
