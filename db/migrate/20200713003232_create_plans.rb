class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :regular_price
      t.integer :week_experience_price
      t.integer :regular_classes_per_week_count
      t.integer :private_lessons_per_month
      t.references :paypal_plan, foreign_key: true

      t.timestamps
    end
  end
end
