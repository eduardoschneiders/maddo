class CheckoutController < AuthenticatedController
  before_action :find_plan_prices, only: [:build_your_plan]
  def build_your_plan
    @private_lessons_prices = @private_lessons.prices.map do |p|
      ["#{p[:count]} -  #{helpers.number_to_currency(p[:price], unit: 'R$')}", p[:count]]
    end

    @regular_classes_prices = @regular_classes.prices.map do |p|
      ["#{p[:count]} -  #{helpers.number_to_currency(p[:price], unit: 'R$')}", p[:count]]
    end

    @week_experience_price = @week_experience.prices.first[:price]
  end

  def generate_plan

    plan = PlanBuilder.new(
      regular_classes_per_week: params[:regular_classes_per_week],
      private_lessons_per_month: params[:private_lessons_per_month],
      week_experience: params[:week_experience]).build

    plan.save

    Subscription.create(user: current_user, plan: plan, status: 'initialized')

    redirect_to confirm_subscription_path
  end

  def confirm_subscription
    @paypal_plan_id = current_user.subscription.plan.paypal_plan.external_id

    @client_id = 'AdAJmAnzt0JI197z9fx2GGaBbRajduTaq_XOjlX9BGl6iICxU5NlbZjTyTyzEqp4zoBJE4D4rR0z5Daq'
    # @plan_id = 'P-273045463V5596003L4BWRKQ'
  end

  def order
    @client_id = 'AdAJmAnzt0JI197z9fx2GGaBbRajduTaq_XOjlX9BGl6iICxU5NlbZjTyTyzEqp4zoBJE4D4rR0z5Daq'
  end

  private

  def find_plan_prices
    @private_lessons = PlanPrice.find_by(kind: 'private_lessons')
    @regular_classes = PlanPrice.find_by(kind: 'regular_classes')
    @week_experience = PlanPrice.find_by(kind: 'week_experience')

    raise Errors::PlanBuilderErrors::PlanPriceNotFound unless @private_lessons && @regular_classes && @week_experience
  end
end
