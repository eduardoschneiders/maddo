module Errors
  class PlanBuilderErrors
    class PlanPriceNotFound < StandardError; end
    class PaypalPlanNotFound < StandardError
      attr_reader :regular_classes_per_week, :private_lessons_per_month, :week_experience

      def initialize(regular_classes_per_week:, private_lessons_per_month:, week_experience:)
        @regular_classes_per_week = regular_classes_per_week
        @private_lessons_per_month = private_lessons_per_month
        @week_experience = week_experience

        super(message)
      end

      def message
        <<-MESSAGE.squish
          Error tring to build plan with params:
          regular_classes_per_week: #{regular_classes_per_week}
          private_lessons_per_month: #{private_lessons_per_month}
          week_experience: #{week_experience}
        MESSAGE
      end
    end
  end
end
