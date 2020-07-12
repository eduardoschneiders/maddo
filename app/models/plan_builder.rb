class PlanBuilder
  attr_reader :regular_class_count, :private_lessons_count, :week_experience

  def initialize(regular_class_count: 0, private_lessons_count: 0, week_experience: false)
    @regular_class_count = regular_class_count
    @private_lessons_count = private_lessons_count
    @week_experience = week_experience
  end

  def build

  end
end
