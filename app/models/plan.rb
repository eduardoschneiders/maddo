class Plan < ApplicationRecord
  belongs_to :paypal_plan
  has_one :subscription
end
