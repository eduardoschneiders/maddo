class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :paypal_order_id
      t.string :items, array: true, default: []
      t.string :deliver_status
      t.string :payment_status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
