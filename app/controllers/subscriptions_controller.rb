class SubscriptionsController < AuthenticatedController
  def show; end

  def cancel
    current_user.subscription.cancel!
    redirect_to subscriptions_path
  end
end
