module Paypal
  class SyncPlansService
    attr_reader :client

    def initialize
      @client = Paypal::ApiClient::Client.new
    end

    def sync
      active_plans.each do |plan_data|
        plan = PaypalPlan.find_or_create_by(external_id: plan_data['id'])
        plan.update(name: plan_data['name'], description: plan_data['description'])
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

    def log(plan)
      Rails::logger.info(
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
