# rubocop:disable Metrics/MethodLength
module Paypal
  class UploadPlansService
    attr_reader :client

    PRODUCT_NAME = 'Aulas de dança Maddo'.freeze

    def initialize
      @client = Paypal::ApiClient::Client.new
    end

    def upload
      plans_metadata = Paypal::PlanCombinationsBuilder.new.build

      plans_metadata.each do |plan_metadata|
        client.create_plan(
          payload: build_payload(plan_metadata, product)
        )
      end
    end

    private

    def product
      @product ||= find_product || raise_product_not_found
    end

    def find_product
      client.fetch_products[:products].find do |product|
        product[:name] == PRODUCT_NAME
      end
    end

    def raise_product_not_found
      raise Paypal::Errors::ProductNotFound.new(
        product_name: PRODUCT_NAME,
        paypal_client_id: Rails.application.credentials.dig(Rails.env.to_sym, :paypal, :client_id)
      )
    end

    def build_payload(plan_metadata, product)
      {
        status: 'ACTIVE',
        product_id: product[:id],
        name: plan_metadata[:name],
        description: plan_metadata[:description],
        payment_preferences: payment_preferences,
        taxes: taxes,
        billing_cycles: billing_cycles(
          regular_price: plan_metadata[:regular_price],
          week_experience: plan_metadata[:week_experience],
          week_experience_price: plan_metadata[:week_experience_price]
        )
      }
    end

    def payment_preferences
      {
        auto_bill_outstanding: true,
        setup_fee: {
          value: '0',
          currency_code: 'BRL'
        },
        setup_fee_failure_action: 'CONTINUE',
        payment_failure_threshold: 3
      }
    end

    def taxes
      {
        percentage: '10',
        inclusive: true
      }
    end

    def billing_cycles(regular_price:, week_experience:, week_experience_price:)
      cicles = [regular_billing_cicle(price: regular_price, sequence: week_experience ? 2 : 1)]
      cicles.push(trial_billing_cicle(price: week_experience_price)) if week_experience

      cicles
    end

    def regular_billing_cicle(price:, sequence:)
      {
        frequency: {
          interval_unit: 'WEEK',
          interval_count: 1
        },
        tenure_type: 'REGULAR',
        sequence: sequence,
        total_cycles: 0,
        pricing_scheme: {
          fixed_price: {
            value: price,
            currency_code: 'BRL'
          }
        }
      }
    end

    def trial_billing_cicle(price:)
      {
        frequency: {
          interval_unit: 'WEEK',
          interval_count: 1
        },
        tenure_type: 'TRIAL',
        sequence: 1,
        total_cycles: 1,
        pricing_scheme: {
          fixed_price: {
            value: price,
            currency_code: 'BRL'
          }
        }
      }
    end
  end
end
# rubocop:enable Metrics/MethodLength
