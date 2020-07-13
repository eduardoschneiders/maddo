FactoryBot.define do
  factory :paypal_plan do
    name { 'Plano mensal com 1 aula particular' }
    description { 'regular_class_0_private_lessons_1_with_0_weekly_experience' }
    external_id { 'P-01280341RK877531GL4FDAXI' }
    regular_price { 100 }
    week_experience_price { 40 }
  end
end
