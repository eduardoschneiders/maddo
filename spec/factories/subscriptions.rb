FactoryBot.define do
  factory :subscription do
    paypal_subscription_id { 'MyString' }
    last_paid_at { '2020-07-13' }
    expiration_date { '2020-07-13' }
    next_billing_at { '2020-07-13' }
    payment_status { 'MyString' }
    status { 'MyString' }
    user { nil }
    plan { nil }
  end
end
