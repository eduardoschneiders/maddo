class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :paypal_subscription_id
      t.date :last_paid_at
      t.date :expiration_date
      t.date :next_billing_at
      t.string :payment_status
      t.string :status
      t.references :user, foreign_key: true
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
