module Paypal
  module ApiClient
    class Client
      HOST = 'https://api.sandbox.paypal.com'.freeze
      ACCESS_TOKEN = Rails.application.credentials.dig(:paypal, :access_token)
      AUTH_PARAMS = { 'Authorization' => "Bearer #{ACCESS_TOKEN}" }.freeze

      def fetch_plans(params: {})
        url = HOST + '/v1/billing/plans'
        response = RestClient.get(url, { params: params }.merge(AUTH_PARAMS))
        JSON.parse(response)
      end
    end
  end
end
