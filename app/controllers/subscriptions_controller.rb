class SubscriptionsController < AuthenticatedController
  def show
    @current_subscription = current_user.current_subscription
  end

  def cancel
    current_user.current_subscription.cancel!
    redirect_to subscriptions_path
  end
end
