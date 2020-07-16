FactoryBot.define do
  factory :plan do
    name { 'Plano mensal com uma aula particular' }
    regular_price { 1 }
    week_experience_price { 1 }
    regular_classes_per_week { 1 }
    private_lessons_per_month { 1 }
    paypal_plan { build :paypal_plan }
  end
end
