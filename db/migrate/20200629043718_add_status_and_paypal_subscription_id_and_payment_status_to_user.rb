class AddStatusAndPaypalSubscriptionIdAndPaymentStatusToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :status, :string
    add_column :users, :paypal_subscription_id, :string
    add_column :users, :payment_status, :string
  end
end
