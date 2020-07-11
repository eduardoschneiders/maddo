class CheckoutController < AuthenticatedController
  def subscription
    @client_id = 'AdAJmAnzt0JI197z9fx2GGaBbRajduTaq_XOjlX9BGl6iICxU5NlbZjTyTyzEqp4zoBJE4D4rR0z5Daq'
    @plan_id = 'P-273045463V5596003L4BWRKQ'
  end

  def order
    @client_id = 'AdAJmAnzt0JI197z9fx2GGaBbRajduTaq_XOjlX9BGl6iICxU5NlbZjTyTyzEqp4zoBJE4D4rR0z5Daq'
  end
end
