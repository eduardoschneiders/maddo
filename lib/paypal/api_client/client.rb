module Paypal
  module ApiClient
    class Client
      HOST = 'https://api.sandbox.paypal.com'.freeze
      USER = Rails.application.credentials.dig(:paypal, :auth, :user)
      SECRET = Rails.application.credentials.dig(:paypal, :auth, :secret)
      AUTH_PARAMS = { 'Authorization' => "Bearer " }.freeze

      def fetch_plans(params: {})
        url = HOST + '/v1/billing/plans'
        response = RestClient.get(url, { params: params }.merge(auth_params).merge(prefer: 'return=representation'))
        JSON.parse(response)
      end

      private

      def auth_params
        { "Authorization" => "Basic " + Base64::strict_encode64("#{USER}:#{SECRET}") }
      end
    end
  end
end
