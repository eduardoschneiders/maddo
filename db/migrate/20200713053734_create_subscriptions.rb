class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :paypal_subscription_id
      t.date :last_paid_at
      t.date :expiration_date
      t.date :next_billing_at
      t.string :status
      t.string :status_changes
      t.string :status_changes_attempts
      t.string :payment_status
      t.string :payment_status_changes
      t.string :payment_status_changes_attempts
      t.references :user, foreign_key: true
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
