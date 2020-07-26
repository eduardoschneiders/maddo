module Paypal
  module Errors
    class ProductNotFound < StandardError
      attr_reader :product_name, :paypal_client_id

      def initialize(product_name:, paypal_client_id:)
        @product_name = product_name
        @paypal_client_id = paypal_client_id

        super(message)
      end

      def message
        <<-MESSAGE.squish
          Product #"#{product_name}" not found for paypal_client_id #"#{paypal_client_id}"
        MESSAGE
      end
    end
  end
end
