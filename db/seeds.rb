# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
u = User.find_or_create_by(email: 'eduardo.m.schneiders@gmail.com').update(password: 'password')
plan_prince = PlanPrice.find_or_create_by(kind: 'private_lessons')
plan_prince.prices = [
  { days_per_month_count: 0, price: 0 },
  { days_per_month_count: 1, price: 90 },
  { days_per_month_count: 2, price: 180 },
  { days_per_month_count: 3, price: 260 },
]

plan_prince.save

plan_prince = PlanPrice.find_or_create_by(kind: 'regular_classes')
plan_prince.prices = [
  { days_per_month_count: 0, price: 0 },
  { days_per_month_count: 1, price: 100 },
  { days_per_month_count: 2, price: 180 },
  { days_per_month_count: 3, price: 260 },
]

plan_prince.save
