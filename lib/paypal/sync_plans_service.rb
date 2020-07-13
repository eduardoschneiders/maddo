module Paypal
  class SyncPlansService
    attr_reader :client

    def initialize
      @client = Paypal::ApiClient::Client.new
    end

    def sync
      active_plans.each do |plan_data|
        plan = PaypalPlan.find_or_create_by(external_id: plan_data['id'])
        update_plan(plan, plan_data)
        log(plan)
      end
    end

    private

    def active_plans
      plans = []
      page = 0

      loop do
        response = client.fetch_plans(params: { page: page += 1 })
        plans << response['plans']

        break unless next?(response)
      end

      filter_active(plans.flatten)
    end

    def next?(response)
      response['links'].find { |e| e['rel'] == 'next' }.present?
    end

    def filter_active(plans)
      plans.select { |plan| plan['status'] == 'ACTIVE' }
    end

    def update_plan(plan, plan_data)
      plan.update(
        name: plan_data['name'],
        description: plan_data['description'],
        regular_price: find_regular_price(plan_data),
        week_experience_price: find_week_experience_price(plan_data)
      )
    end

    def find_regular_price(plan_data)
      cicle = find_biiling_cicle(plan_data, 'REGULAR')
      return unless cicle

      cicle['pricing_scheme']['fixed_price']['value'].to_i
    end

    def find_week_experience_price(plan_data)
      cicle = find_biiling_cicle(plan_data, 'TRIAL')
      return unless cicle

      cicle['pricing_scheme']['fixed_price']['value'].to_i
    end

    def find_biiling_cicle(plan_data, tenure_type)
      plan_data['billing_cycles'].find do |cicle|
        cicle['tenure_type'] == tenure_type
      end
    end

    def log(plan)
      Rails.logger.info(
        <<-LOG
          [SyncPlansService] plan synced.
          external_id: #{plan.external_id},
          name: #{plan.name},
          description: #{plan.description},
        LOG
      )
    end
  end
end
