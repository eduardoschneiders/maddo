class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:add_paypal_subscription_id, :create_order]

  def add_paypal_subscription_id
    current_user.current_subscription.update(
      paypal_subscription_id: params[:paypal_subscription_id]
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
