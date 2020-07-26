module Paypal
  module ApiClient
    class Client
      HOST = 'https://api.sandbox.paypal.com'.freeze
      USER = Rails.application.credentials.dig(Rails.env.to_sym, :paypal, :client_id)
      SECRET = Rails.application.credentials.dig(Rails.env.to_sym, :paypal, :secret)

      def fetch_products
        url = "#{HOST}/v1/catalogs/products/"
        response = RestClient.get(url, default_headers)
        JSON.parse(response, symbolize_names: true)
      end

      def fetch_plans(params: {})
        url = HOST + '/v1/billing/plans'
        response = RestClient.get(url, { params: params }.merge(default_headers).merge(prefer: 'return=representation'))
        JSON.parse(response)
      end

      def create_plan(payload: {})
        response = RestClient.post(
          "#{HOST}/v1/billing/plans",
          payload.to_json,
          default_headers
        )

        JSON.parse(response)
      end

      def billing_agreement(id:)
        response = RestClient.get(
          "#{HOST}/v1/payments/billing-agreements/#{id}",
          default_headers
        )

        JSON.parse(response, symbolize_names: true)
      end

      private

      def default_headers
        {
          'Authorization' => 'Basic ' + Base64.strict_encode64("#{USER}:#{SECRET}"),
          content_type: :json
        }
      end
    end
  end
end
