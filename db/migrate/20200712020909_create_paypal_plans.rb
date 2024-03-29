class CreatePaypalPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :paypal_plans do |t|
      t.string :external_id
      t.string :name
      t.string :description
      t.integer :regular_price
      t.integer :week_experience_price

      t.timestamps
    end
  end
end
