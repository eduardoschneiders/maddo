FactoryBot.define do
  factory :plan_price do
    kind { 'private_lessons' }
    prices do
      [
        { count: 0, price: 0 },
        { count: 1, price: 90 },
        { count: 2, price: 180 },
        { count: 3, price: 260 }
      ]
    end
  end
end
