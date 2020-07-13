module Errors
  class PlanBuilderErrors
    class PaypalPlanNotFound < StandardError; end
    class PlanPriceNotFound < StandardError; end
  end
end
