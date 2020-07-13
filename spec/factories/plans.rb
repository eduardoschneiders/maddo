FactoryBot.define do
  factory :plan do
    name { "MyString" }
    regular_price { 1 }
    week_experience_price { 1 }
    regular_classes_per_week_count { 1 }
    private_lessons_per_month { 1 }
    paypal_plans { nil }
  end
end
