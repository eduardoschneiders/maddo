FactoryBot.define do
  factory :subscription do
    paypal_subscription_id { 'foobar' }
    last_paid_at { '2020-07-13' }
    expiration_date { '2020-07-13' }
    next_billing_at { '2020-07-13' }
    user { create(:user) }
    plan { create(:plan) }
  end
end
