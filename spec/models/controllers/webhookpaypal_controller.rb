require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Webhookpaypal', type: :request do
  describe 'POST create' do
    before do
      post webhookpaypal_path, params: params
      subscription.reload
    end

    let(:params) do
      {
        resource_type: 'subscription',
        event_type: event_type,
        resource: {
          id: subscription.paypal_subscription_id
        }
      }
    end

    let(:event_type) { 'BILLING.SUBSCRIPTION.CREATED' }

    let(:subscription) do
      create(:subscription,
        paypal_subscription_id: 'some_uniq_subscription_id')
    end

    context 'when event is unknown' do
      let(:event_type) { 'unkown event type' }

      it 'set the subscription to the state payment_created' do
        expect(subscription).to be_initialized
        expect(subscription).to be_payment_initialized
      end
    end

    context 'when event is BILLING.SUBSCRIPTION.CREATED' do
      let(:event_type) { 'BILLING.SUBSCRIPTION.CREATED' }

      it 'set the subscription to the state payment_created' do
        expect(subscription).to be_initialized
        expect(subscription).to be_payment_subscription_created
      end
    end

    context 'when event is BILLING.SUBSCRIPTION.ACTIVATED' do
      let(:event_type) { 'BILLING.SUBSCRIPTION.ACTIVATED' }

      it 'set the subscription to the state payment_created' do
        expect(subscription).to be_initialized
        expect(subscription).to be_payment_subscription_activated
      end
    end

    context 'when event is PAYMENT.SALE.COMPLETED' do
      let(:event_type) { 'PAYMENT.SALE.COMPLETED' }

      it 'set the subscription to the state payment_created' do
        expect(subscription).to be_active
        expect(subscription).to be_payment_sale_completed
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
