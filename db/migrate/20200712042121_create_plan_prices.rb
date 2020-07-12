class CreatePlanPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_prices do |t|
      t.string :kind
      t.string :prices

      t.timestamps
    end
  end
end
