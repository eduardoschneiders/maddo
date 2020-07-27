class AddCanceledAtToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :canceled_at, :date
  end
end
