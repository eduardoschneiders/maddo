module Paypal
  module Errors
    class BillingAgreementNotFound < StandardError
      attr_reader :paypal_subscription_id

      def initialize(paypal_subscription_id:)
        @paypal_subscription_id = paypal_subscription_id

        super(message)
      end

      def message
        <<-MESSAGE.squish
          Billing agreement with paypal_subscription_id #"#{paypal_subscription_id}" not found"
        MESSAGE
      end
    end
  end
end
