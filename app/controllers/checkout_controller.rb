class CheckoutController < AuthenticatedController
  before_action :find_plan_prices, only: [:build_your_plan]

  def build_your_plan
    @private_lessons_prices = @private_lessons.prices.map { |price| select_values(price) }

    @regular_classes_prices = @regular_classes.prices.map { |price| select_values(price) }

    @week_experience_price = @week_experience.prices.first[:price]
  end

  def generate_plan
    plan = PlanBuilder.new(
      regular_classes_per_week: params[:regular_classes_per_week],
      private_lessons_per_month: params[:private_lessons_per_month],
      week_experience: params[:week_experience]
    ).build

    plan.save

    current_user.subscriptions.create(plan: plan)

    redirect_to confirm_subscription_path
  end

  def confirm_subscription
    @paypal_plan_id = current_user.current_subscription.plan.paypal_plan.external_id

    @paypal_client_id = Rails.application.credentials.dig(Rails.env.to_sym, :paypal, :client_id)
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

  def select_values(price)
    ["#{price[:count]} -  #{helpers.number_to_currency(price[:price], unit: 'R$')}", price[:count]]
  end
end
