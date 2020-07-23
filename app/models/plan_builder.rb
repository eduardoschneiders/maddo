class PlanBuilder
  attr_reader :regular_classes_per_week, :private_lessons_per_month, :week_experience

  def initialize(regular_classes_per_week: 0, private_lessons_per_month: 0, week_experience: false)
    @regular_classes_per_week = regular_classes_per_week
    @private_lessons_per_month = private_lessons_per_month
    @week_experience = week_experience
  end

  def build
    paypal_plan = find_paypal_plan
    raise_error unless paypal_plan

    Plan.new(
      paypal_plan: paypal_plan,
      name: paypal_plan.name,
      regular_price: paypal_plan.regular_price,
      week_experience_price: paypal_plan.week_experience_price,
      regular_classes_per_week: regular_classes_per_week,
      private_lessons_per_month: private_lessons_per_month
    )
  end

  private

  def find_paypal_plan
    PaypalPlan.find_by(description: build_description_key)
  end

  def raise_error
    raise Errors::PlanBuilderErrors::PaypalPlanNotFound.new(
      regular_classes_per_week: regular_classes_per_week,
      private_lessons_per_month: private_lessons_per_month,
      week_experience: week_experience
    )
  end

  def build_description_key
    regular_key + private_lessons_key + weekly_experiece_key
  end

  def regular_key
    "regular_class_#{regular_classes_per_week}"
  end

  def private_lessons_key
    "_private_lessons_#{private_lessons_per_month}"
  end

  def weekly_experiece_key
    "_with_#{week_experience ? 1 : 0}_weekly_experience"
  end
end
