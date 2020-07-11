class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :paypal_subscription_id
      t.date :expiration_date
      t.string :kind, default: 'basic_plan'
      t.string :payment_status
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
