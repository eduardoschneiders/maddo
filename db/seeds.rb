# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.find_or_create_by(email: 'eduardo.m.schneiders@gmail.com')
  .update(password: 'eduardo', password_confirmation: 'eduardo')

PlanPrice.find_or_create_by(kind: 'private_lessons').tap do |plan_prince|
  plan_prince.prices = [
    { count: 0, price: 0 },
    { count: 1, price: 90 },
    { count: 2, price: 180 },
    { count: 3, price: 260 },
  ]

  plan_prince.save
end

PlanPrice.find_or_create_by(kind: 'regular_classes').tap do |plan_prince|
  plan_prince.prices = [
    { count: 0, price: 0 },
    { count: 1, price: 100 },
    { count: 2, price: 180 },
    { count: 3, price: 260 },
  ]

  plan_prince.save
end

PlanPrice.find_or_create_by(kind: 'week_experience').tap do |plan_prince|
  plan_prince.prices = [ { price: 40 } ]

  plan_prince.save
end

PaypalPlan.find_or_create_by(
  external_id: 'P-8JN56176UF382904TL4FDBUA',
  name: 'z mensal com 1 aula particular e 1 semana de olhadinha',
  description: 'regular_class_0_private_lessons_1_with_1_weekly_experience',
  regular_price: 90,
  week_experience_price: 40
)

plan = PlanBuilder.new(regular_classes_per_week: 0, private_lessons_per_month: 1, week_experience: true).build
plan.save
Subscription.create(user: User.first, plan: plan, status: 'initialized')

p ('-' * 100) + ' Seed done'
